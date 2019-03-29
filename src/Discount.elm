module Discount exposing (Discount, selection, view)

import Api.Object.DiscountedProductInfo
import Api.Scalar exposing (ProductCode)
import Api.Union
import Api.Union.DiscountedProductInfoOrError
import Element exposing (Element)
import Element.Input
import Graphql.SelectionSet as SelectionSet
import RemoteData exposing (RemoteData)


type Discount
    = Discount DiscountStatus


type DiscountStatus
    = Expired
    | Valid Int ProductCode
    | NotFound


selection : SelectionSet.SelectionSet Discount Api.Union.DiscountedProductInfoOrError
selection =
    Api.Union.DiscountedProductInfoOrError.fragments
        { onDiscountExpired = SelectionSet.succeed Expired
        , onDiscountNotFound = SelectionSet.succeed NotFound
        , onDiscountedProductInfo =
            SelectionSet.map2 Valid
                Api.Object.DiscountedProductInfo.discountedPrice
                Api.Object.DiscountedProductInfo.appliesTo
        }
        |> SelectionSet.map Discount


view : Discount -> Element msg
view discount =
    (case discount of
        Discount Expired ->
            "\u{1F6D1} Expired"

        Discount (Valid discountedPrice appliesTo) ->
            "✅"

        Discount NotFound ->
            "NotFound"
    )
        |> Element.text
