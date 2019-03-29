module Scalar exposing (Dollars, ProductCode, codecs)

import Api.Scalar exposing (defaultCodecs)
import Dollars
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode


type alias Dollars =
    Dollars.Dollars


type alias ProductCode =
    Api.Scalar.ProductCode


codecs : Api.Scalar.Codecs Dollars ProductCode
codecs =
    Api.Scalar.defineCodecs
        { codecDollars = Dollars.codec
        , codecProductCode = defaultCodecs.codecProductCode
        }
