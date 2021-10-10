module Article exposing (..)

import DataSource exposing (DataSource)
import DataSource.File as File
import DataSource.Glob as Glob
import Date exposing (Date)
import OptimizedDecoder
import Route exposing (Route)


type alias BlogPost =
    { filePath : String, slug : String }


type alias ArticleMetadata =
    { title : String
    , description : String
    , published : Date
    , draft : Bool
    }


blogPostsGlob : DataSource (List BlogPost)
blogPostsGlob =
    Glob.succeed BlogPost
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource


allMetadata : DataSource (List ( Route, ArticleMetadata ))
allMetadata =
    blogPostsGlob
        |> DataSource.map
            (\paths ->
                paths
                    |> List.map
                        (\{ filePath, slug } ->
                            DataSource.map2 Tuple.pair
                                (DataSource.succeed <| Route.Blog__Slug_ { slug = slug })
                                (File.onlyFrontmatter frontmatterDecoder filePath)
                        )
            )
        |> DataSource.resolve
        |> DataSource.map
            (\articles ->
                articles
                    |> List.filterMap
                        (\( route, metadata ) ->
                            if metadata.draft then
                                Nothing

                            else
                                Just ( route, metadata )
                        )
            )
        |> DataSource.map
            (List.sortBy
                (\( route, metadata ) -> -(Date.toRataDie metadata.published))
            )


frontmatterDecoder : OptimizedDecoder.Decoder ArticleMetadata
frontmatterDecoder =
    OptimizedDecoder.map4 ArticleMetadata
        (OptimizedDecoder.field "title" OptimizedDecoder.string)
        (OptimizedDecoder.field "description" OptimizedDecoder.string)
        (OptimizedDecoder.field "published"
            (OptimizedDecoder.string
                |> OptimizedDecoder.andThen
                    (\isoString ->
                        case Date.fromIsoString isoString of
                            Ok date ->
                                OptimizedDecoder.succeed date

                            Err error ->
                                OptimizedDecoder.fail error
                    )
            )
        )
        (OptimizedDecoder.field "draft" OptimizedDecoder.bool
            |> OptimizedDecoder.maybe
            |> OptimizedDecoder.map (Maybe.withDefault False)
        )
