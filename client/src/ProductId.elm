module ProductId exposing (ProductId, codec, linkTo, selection)

import Element exposing (Element)
import Graphql.Codec exposing (Codec)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Json.Decode exposing (Decoder)
import Json.Encode


type ProductId
    = ProductId


selection : SelectionSet ProductId typeContext
selection =
    SelectionSet.succeed ProductId


linkTo : ProductId -> List (Element.Attribute msg) -> Element msg -> Element msg
linkTo productId attributes label =
    Element.link attributes
        { url = "/item"
        , label = label
        }


codec : Codec ProductId
codec =
    { encoder = encode
    , decoder = decoder
    }


decoder : Decoder ProductId
decoder =
    Json.Decode.succeed ProductId


encode : ProductId -> Json.Encode.Value
encode ProductId =
    Json.Encode.null
