module ProductId exposing (ProductId, codec, linkTo, urlParser)

import Element exposing (Element)
import Graphql.Codec exposing (Codec)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Url.Builder
import Url.Parser as Parser exposing ((</>), Parser, int, oneOf, s, string)


type ProductId
    = ProductId Int


linkTo : ProductId -> List (Element.Attribute msg) -> Element msg -> Element msg
linkTo (ProductId id) attributes label =
    Element.link attributes
        { url = Url.Builder.absolute [ "item", String.fromInt id ] []
        , label = label
        }


codec : Codec ProductId
codec =
    { encoder = \(ProductId id) -> Encode.int id
    , decoder = Decode.map ProductId Decode.int
    }


urlParser : Parser (ProductId -> route) route
urlParser =
    int |> Parser.map ProductId
