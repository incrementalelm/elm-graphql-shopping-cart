module Discount exposing (Discount, selection, view)

import Api.Union
import Api.Union.DiscountedProductInfoOrError
import Element exposing (Element)
import Element.Input
import Graphql.SelectionSet as SelectionSet
import RemoteData exposing (RemoteData)


type Discount
    = Discount


selection : SelectionSet.SelectionSet Discount Api.Union.DiscountedProductInfoOrError
selection =
    SelectionSet.succeed Discount


view : { model | discountCode : String, discountInfo : RemoteData e Discount } -> Element String
view { discountCode, discountInfo } =
    Element.row [ Element.width Element.fill ]
        [ Element.Input.text []
            { onChange = identity
            , text = discountCode
            , placeholder = Nothing
            , label = Element.Input.labelLeft [] Element.none
            }
        , discountInfoView discountInfo
        ]


discountInfoView : RemoteData e Discount -> Element msg
discountInfoView remoteDiscountInfo =
    case remoteDiscountInfo of
        RemoteData.NotAsked ->
            Element.text "Discount code"

        RemoteData.Loading ->
            Element.text "Discount code..."

        RemoteData.Failure e ->
            Element.text "Discount code X"

        RemoteData.Success discount ->
            Element.text "Discount code"
