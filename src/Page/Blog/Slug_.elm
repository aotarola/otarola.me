module Page.Blog.Slug_ exposing (Data, Model, Msg, page)

import Article exposing (ArticleMetadata, frontmatterDecoder)
import DataSource exposing (DataSource)
import Date
import Head
import Head.Seo as Seo
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr exposing (css)
import MarkdownCodec
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw
import TailwindMarkdownRenderer exposing (renderer)
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { slug : String }


page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    Article.blogPostsGlob
        |> DataSource.map
            (List.map
                (\globData ->
                    { slug = globData.slug }
                )
            )


data : RouteParams -> DataSource Data
data { slug } =
    MarkdownCodec.withFrontmatter Data
        frontmatterDecoder
        renderer
        ("content/" ++ slug ++ ".md")


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    { metadata : ArticleMetadata, body : List (Html Msg) }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel staticPayload =
    { title = staticPayload.data.metadata.title
    , body =
        [ div
            [ css
                [ Tw.max_w_3xl
                , Tw.mx_auto
                , Tw.px_4
                , Bp.sm [ Tw.px_6 ]
                ]
            ]
            [ main_ []
                [ article
                    [ css
                        [ Bp.xl
                            [ Tw.divide_y
                            , Tw.divide_gray_200
                            ]
                        ]
                    ]
                    [ headerView staticPayload.data.metadata
                    , bodyView staticPayload.data.body
                    ]
                ]
            ]
        ]
    }


bodyView : List (Html msg) -> Html msg
bodyView body =
    div
        [ css
            [ Tw.divide_y
            , Tw.divide_gray_200
            ]
        ]
        [ div
            [ css
                [ Tw.max_w_none
                , Tw.pt_10
                , Tw.pb_8
                ]
            ]
            [ div
                [ css
                    [ Tw.prose
                    , Tw.max_w_none
                    , Tw.text_gray_600
                    ]
                ]
                body
            ]
        ]


headerView : ArticleMetadata -> Html msg
headerView metadata =
    header
        [ css
            [ Tw.pt_6
            , Bp.xl
                [ Tw.pb_10
                ]
            ]
        ]
        [ div
            [ css
                [ Tw.space_y_1
                , Tw.text_center
                ]
            ]
            [ dl [ css [ Tw.space_y_10 ] ]
                [ dd [ css [ Tw.sr_only ] ] []
                , dd
                    [ css
                        [ Tw.text_base
                        , Tw.font_medium
                        , Tw.text_gray_500
                        ]
                    ]
                    [ time
                        [ Attr.datetime "2020-03-16"

                        -- HACK: actually make it dynamic
                        ]
                        [ text (metadata.published |> Date.format "MMMM ddd, yyyy") ]
                    ]
                ]
            , div []
                [ h1
                    [ css
                        [ Tw.text_3xl
                        , Tw.font_extrabold
                        , Tw.text_gray_900
                        , Tw.tracking_tight
                        , Bp.sm [ Tw.text_4xl ]
                        , Bp.md [ Tw.text_5xl, Tw.leading_3 ] -- FIX: figure out how to do md:leading-[3.5rem]
                        ]
                    ]
                    [ text metadata.title ]
                ]
            ]
        ]
