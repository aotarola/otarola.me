module View.Header exposing (..)

import Css
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr exposing (css)
import Tailwind.Utilities as Tw


view : Html msg
view =
    div [ css [ Tw.antialiased ] ]
        [ nav
            [ css
                [ Tw.flex
                , Tw.justify_between
                , Tw.bg_white
                , Tw.shadow_lg
                ]
            ]
            [ div [ css [ Tw.px_8, Tw.py_4 ] ]
                [ div
                    [ css
                        [ Tw.text_green_500
                        , Tw.font_semibold
                        ]
                    ]
                    [ a [] [ text "otarola.me" ] ]
                ]
            , ul [ css [ Tw.flex, Tw.justify_start, Tw.px_4 ] ]
                [ li
                    [ css
                        [ Tw.py_4
                        , Tw.px_4
                        , Tw.text_green_500
                        , Tw.border_b_4
                        , Tw.border_green_500
                        , Tw.ml_auto
                        ]
                    ]
                    [ a [ Attr.href "/" ] [ text "Blog" ] ]
                , li
                    [ css
                        [ Tw.py_4
                        , Tw.px_4
                        , Tw.text_gray_500
                        , Tw.font_semibold
                        , Css.hover [ Tw.text_green_500 ]
                        , Tw.transition
                        , Tw.duration_300
                        ]
                    ]
                    [ a [ Attr.href "/" ] [ text "About" ] ]
                ]
            ]
        ]


headerLink name =
    a [] [ linkInner name ]


linkInner name =
    span [ css [ Tw.text_sm ] ] [ text name ]
