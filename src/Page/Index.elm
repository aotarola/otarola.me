module Page.Index exposing (Data, Model, Msg, page)

import Article exposing (ArticleMetadata)
import Css
import DataSource exposing (DataSource)
import Date
import Head
import Head.Seo as Seo
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr exposing (css)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Route exposing (Route)
import Shared
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    Article.allMetadata


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
    List ( Route, ArticleMetadata )


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data {}
    -> View msg
view maybeUrl sharedModel staticPayload =
    { title = "Index page"
    , body =
        [ div
            [ css
                [ Tw.max_w_3xl
                , Tw.mx_auto
                , Tw.px_4
                , Bp.sm [ Tw.px_6 ]
                , Bp.xl [ Tw.max_w_5xl, Tw.px_0 ]
                ]
            ]
            [ main_ []
                [ ul
                    [ css
                        [ Tw.divide_y
                        , Tw.divide_gray_200
                        ]
                    ]
                    (staticPayload.data
                        |> List.map
                            (\articleInfo ->
                                articleView articleInfo
                            )
                    )
                ]
            ]
        ]
    }


link : Route.Route -> List (Attribute msg) -> List (Html msg) -> Html msg
link route attrs children =
    Route.toLink
        (\anchorAttrs ->
            a
                (List.map Attr.fromUnstyled anchorAttrs ++ attrs)
                children
        )
        route


articleView : ( Route, ArticleMetadata ) -> Html msg
articleView ( route, metadata ) =
    li [ css [ Tw.py_12 ] ]
        [ article
            [ css
                [ Tw.space_y_2
                , Bp.xl
                    [ Tw.grid
                    , Tw.grid_cols_4
                    , Tw.space_y_0
                    , Tw.items_baseline
                    ]
                ]
            ]
            [ dl []
                [ dt
                    [ css
                        [ Tw.sr_only
                        ]
                    ]
                    [ text "Published on" ]
                , dd
                    [ css
                        [ Tw.text_base
                        , Tw.font_medium
                        , Tw.text_gray_500
                        ]
                    ]
                    [ time
                        [ Attr.datetime "2020-03-16"

                        -- TODO: actually make it dynamic
                        ]
                        [ text (metadata.published |> Date.format "MMMM ddd, yyyy") ]
                    ]
                ]
            , div
                [ css
                    [ Tw.space_y_5
                    , Bp.xl
                        [ Tw.col_span_3
                        ]
                    ]
                ]
                [ div [ css [ Tw.space_y_6 ] ]
                    [ h2
                        [ css
                            [ Tw.text_2xl
                            , Tw.font_bold
                            , Tw.tracking_tight
                            ]
                        ]
                        [ link route
                            [ css [ Tw.text_green_500 ]
                            ]
                            [ text metadata.title ]
                        ]
                    , div
                        [ css
                            [ Tw.prose
                            , Tw.max_w_none
                            , Tw.text_gray_500
                            ]
                        ]
                        [ div
                            [ css
                                [ Tw.prose
                                , Tw.max_w_none
                                ]
                            ]
                            [ p [] [ text metadata.description ] ]
                        ]
                    ]
                , div
                    [ css
                        [ Tw.text_base
                        , Tw.font_medium
                        ]
                    ]
                    [ link
                        route
                        [ css
                            [ Tw.text_green_500
                            , Css.hover [ Tw.text_green_600 ]
                            ]
                        ]
                        [ text "Read more →" ]
                    ]
                ]
            ]
        ]
