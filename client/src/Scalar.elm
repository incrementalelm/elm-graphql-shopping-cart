module Scalar exposing (Dollars, ProductCode, ProductId, codecs)

import Api.Scalar exposing (defaultCodecs)
import Dollars
import ProductId


type alias Dollars =
    Dollars.Dollars


type alias ProductId =
    ProductId.ProductId


type alias ProductCode =
    Api.Scalar.ProductCode


codecs : Api.Scalar.Codecs Dollars ProductCode ProductId
codecs =
    Api.Scalar.defineCodecs
        { codecDollars = Dollars.codec
        , codecProductCode = defaultCodecs.codecProductCode
        , codecProductId = ProductId.codec
        }
