module ProductId exposing (ProductId, codec, linkTo, urlParser)

import Element exposing (Element)
import Graphql.Codec exposing (Codec)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Json.Decode exposing (Decoder)
import Json.Encode
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
    { encoder = encode
    , decoder = decoder
    }


decoder : Decoder ProductId
decoder =
    Json.Decode.map ProductId Json.Decode.int


encode : ProductId -> Json.Encode.Value
encode (ProductId id) =
    Json.Encode.int id


urlParser : Parser (ProductId -> route) route
urlParser =
    int |> Parser.map ProductId
