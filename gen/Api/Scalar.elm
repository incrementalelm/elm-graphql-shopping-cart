-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.Scalar exposing (Codecs, Dollars(..), ProductCode(..), defaultCodecs, defineCodecs, unwrapCodecs, unwrapEncoder)

import Graphql.Codec exposing (Codec)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode


type Dollars
    = Dollars String


type ProductCode
    = ProductCode String


defineCodecs :
    { codecDollars : Codec valueDollars
    , codecProductCode : Codec valueProductCode
    }
    -> Codecs valueDollars valueProductCode
defineCodecs definitions =
    Codecs definitions


unwrapCodecs :
    Codecs valueDollars valueProductCode
    ->
        { codecDollars : Codec valueDollars
        , codecProductCode : Codec valueProductCode
        }
unwrapCodecs (Codecs unwrappedCodecs) =
    unwrappedCodecs


unwrapEncoder getter (Codecs unwrappedCodecs) =
    (unwrappedCodecs |> getter |> .encoder) >> Graphql.Internal.Encode.fromJson


type Codecs valueDollars valueProductCode
    = Codecs (RawCodecs valueDollars valueProductCode)


type alias RawCodecs valueDollars valueProductCode =
    { codecDollars : Codec valueDollars
    , codecProductCode : Codec valueProductCode
    }


defaultCodecs : RawCodecs Dollars ProductCode
defaultCodecs =
    { codecDollars =
        { encoder = \(Dollars raw) -> Encode.string raw
        , decoder = Object.scalarDecoder |> Decode.map Dollars
        }
    , codecProductCode =
        { encoder = \(ProductCode raw) -> Encode.string raw
        , decoder = Object.scalarDecoder |> Decode.map ProductCode
        }
    }
