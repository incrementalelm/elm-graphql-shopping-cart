module Scalar exposing (Dollars, ProductCode, codecs)

import Api.Scalar exposing (defaultCodecs)
import Dollars


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
