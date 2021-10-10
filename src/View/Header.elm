module View.Header exposing (..)

import Css
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr exposing (css)
import Path exposing (Path)
import Tailwind.Utilities as Tw


view : Path -> Html msg
view currentPath =
    div [ css [ Tw.antialiased ] ]
        [ nav
            [ css
                [ Tw.flex
                , Tw.justify_between
                , Tw.bg_white
                , Tw.shadow_lg
                ]
            ]
            [ homePageLink
            , otherLinks currentPath
            ]
        ]


link : Path -> Maybe String -> String -> Html msg
link currentPath linkTo name =
    let
        isCurrentPath : Bool
        isCurrentPath =
            List.head (Path.toSegments currentPath) == linkTo
    in
    li
        [ css
            [ Tw.py_4
            , Tw.px_4
            , Tw.text_green_500
            , if isCurrentPath then
                Css.batch
                    [ Tw.border_b_4
                    , Tw.border_green_500
                    ]

              else
                Css.batch
                    [ Tw.text_gray_500
                    , Tw.font_semibold
                    , Css.hover [ Tw.text_green_500 ]
                    , Tw.transition
                    , Tw.duration_300
                    ]
            ]
        ]
        [ a [ Attr.href <| Maybe.withDefault "/" linkTo ] [ text name ] ]


to : String -> Maybe String
to s =
    case s of
        "/" ->
            Nothing

        _ ->
            Just s


otherLinks : Path -> Html msg
otherLinks currentPath =
    ul [ css [ Tw.flex, Tw.justify_start, Tw.px_4 ] ]
        [ link currentPath (to "/") "Blog"
        , link currentPath (to "/about") "About"
        ]


homePageLink : Html msg
homePageLink =
    div [ css [ Tw.px_8, Tw.py_4 ] ]
        [ div
            [ css
                [ Tw.text_green_500
                , Tw.font_semibold
                ]
            ]
            [ a [ Attr.href "/" ] [ text "otarola.me" ] ]
        ]
