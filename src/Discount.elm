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



-- SelectionSet.succeed Discount


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
            Element.text ""

        RemoteData.Loading ->
            Element.text "..."

        RemoteData.Failure e ->
            Element.text "Failed to load"

        RemoteData.Success discount ->
            (case discount of
                Discount Expired ->
                    "Expired"

                Discount Valid ->
                    "Valid"

                Discount NotFound ->
                    "NotFound"
            )
                |> Element.text
