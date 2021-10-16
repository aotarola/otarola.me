module Plugins.Cloudinary exposing (url)

import MimeType
import Pages.Url exposing (Url)


url : String -> Maybe MimeType.MimeImage -> Int -> Url
url asset format width =
    let
        base =
            "https://res.cloudinary.com/aotarola/image/upload"

        fetchFormat =
            case format of
                Just MimeType.Png ->
                    "png"

                Just (MimeType.OtherImage "webp") ->
                    "webp"

                Just _ ->
                    "auto"

                Nothing ->
                    "auto"

        transforms =
            [ "c_pad", "w_" ++ String.fromInt width, "q_auto", "f_" ++ fetchFormat ]
                |> String.join ","
    in
    Pages.Url.external (base ++ "/" ++ transforms ++ "/" ++ asset)
