module Discount exposing (Discount, selection, view)

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
    | Valid
    | NotFound


selection : SelectionSet.SelectionSet Discount Api.Union.DiscountedProductInfoOrError
selection =
    Api.Union.DiscountedProductInfoOrError.fragments
        { onDiscountExpired = SelectionSet.succeed Expired
        , onDiscountNotFound = SelectionSet.succeed NotFound
        , onDiscountedProductInfo = SelectionSet.succeed Valid
        }
        |> SelectionSet.map Discount


view : Discount -> Element msg
view discount =
    (case discount of
        Discount Expired ->
            "\u{1F6D1} Expired"

        Discount Valid ->
            "✅"

        Discount NotFound ->
            "NotFound"
    )
        |> Element.text
