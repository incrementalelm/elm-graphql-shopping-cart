module Dollars exposing (Dollars, codec, toString)

import Graphql.Codec exposing (Codec)
import Json.Decode exposing (Decoder)
import Json.Encode


type Dollars
    = Dollars Details


type alias Details =
    { dollars : Int }


codec : Codec Dollars
codec =
    { encoder = encode
    , decoder = decoder
    }


decoder : Decoder Dollars
decoder =
    Json.Decode.int
        |> Json.Decode.map Details
        |> Json.Decode.map Dollars


encode : Dollars -> Json.Encode.Value
encode (Dollars { dollars }) =
    Json.Encode.int dollars


toString : Dollars -> String
toString (Dollars { dollars }) =
    "$" ++ String.fromInt dollars
