module StructuredData exposing (article, elmLang, person, softwareSourceCode)

import Json.Encode as Encode
import Pages.Url


type alias Person =
    { name : String }


type alias Article =
    { title : String
    , description : String
    , author : Encode.Value
    , publisher : Encode.Value
    , url : String
    , imageUrl : Pages.Url.Url
    , datePublished : String
    , mainEntityOfPage : Encode.Value
    }


type alias SoftwareSourceCode =
    { codeRepositoryUrl : String
    , description : String
    , author : String
    , programmingLanguage : Encode.Value
    }


type alias ComputerLanguage =
    { url : String
    , name : String
    , imageUrl : String
    , identifier : String
    }


{-| <https://schema.org/Person>
-}
person : Person -> Encode.Value
person info =
    Encode.object
        [ ( "@type", Encode.string "Person" )
        , ( "name", Encode.string info.name )
        ]


{-| <https://schema.org/SoftwareSourceCode>
-}
softwareSourceCode : SoftwareSourceCode -> Encode.Value
softwareSourceCode info =
    Encode.object
        [ ( "@type", Encode.string "SoftwareSourceCode" )
        , ( "codeRepository", Encode.string info.codeRepositoryUrl )
        , ( "description", Encode.string info.description )
        , ( "author", Encode.string info.author )
        , ( "programmingLanguage", info.programmingLanguage )
        ]


{-| <https://schema.org/Article>
-}
article : Article -> Encode.Value
article info =
    Encode.object
        [ ( "@context", Encode.string "http://schema.org/" )
        , ( "@type", Encode.string "Article" )
        , ( "headline", Encode.string info.title )
        , ( "description", Encode.string info.description )
        , ( "image", Encode.string (Pages.Url.toString info.imageUrl) )
        , ( "author", info.author )
        , ( "publisher", info.publisher )
        , ( "url", Encode.string info.url )
        , ( "datePublished", Encode.string info.datePublished )
        , ( "mainEntityOfPage", info.mainEntityOfPage )
        ]


computerLanguage : ComputerLanguage -> Encode.Value
computerLanguage info =
    Encode.object
        [ ( "@type", Encode.string "ComputerLanguage" )
        , ( "url", Encode.string info.url )
        , ( "name", Encode.string info.name )
        , ( "image", Encode.string info.imageUrl )
        , ( "identifier", Encode.string info.identifier )
        ]


elmLang : Encode.Value
elmLang =
    computerLanguage
        { url = "http://elm-lang.org/"
        , name = "Elm"
        , imageUrl = "http://elm-lang.org/"
        , identifier = "http://elm-lang.org/"
        }
