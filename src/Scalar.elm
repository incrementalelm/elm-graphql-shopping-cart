module Scalar exposing (Dollars, ProductCode, codecs)

import Api.Scalar exposing (defaultCodecs)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode


type alias Dollars =
    Int


type alias ProductCode =
    Api.Scalar.ProductCode


codecs : Api.Scalar.Codecs Dollars ProductCode
codecs =
    Api.Scalar.defineCodecs
        { codecDollars =
            { encoder = \cents -> Encode.int cents
            , decoder = Decode.int
            }
        , codecProductCode = defaultCodecs.codecProductCode
        }
