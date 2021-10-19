module Data.Author exposing (avatar, name, repo)

import Pages.Url exposing (Url)
import Plugins.Cloudinary as Cloudinary


name : String
name =
    "Andres Otarola"


repo : String
repo =
    "https://github.com/aotarola"


avatar : Url
avatar =
    Cloudinary.url "v1634655575/otarola.me/me_small_dvvlkr.png" Nothing 140
