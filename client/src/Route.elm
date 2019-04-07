module Route exposing (Route(..), fromUrl)

import ProductId exposing (ProductId)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, int, oneOf, s, string)


type Route
    = Home
    | Product


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser url


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map (\_ -> Product) (s "item" </> int)
        ]
