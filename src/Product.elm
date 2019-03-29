module Product exposing (Product, selection, view)

import Api.Object
import Api.Object.DiscountedProductInfo
import Api.Object.Product
import Api.Scalar
import Discount exposing (Discount)
import Dollars exposing (Dollars)
import Element exposing (Element)
import Element.Font
import Element.Input
import Graphql.SelectionSet as SelectionSet
import RemoteData exposing (RemoteData)


type Product
    = Product Details


type alias Details =
    { code : Api.Scalar.ProductCode
    , name : String
    , imageUrl : String
    , price : Dollars
    }


selection : SelectionSet.SelectionSet Product Api.Object.Product
selection =
    SelectionSet.map4 Details
        Api.Object.Product.code
        Api.Object.Product.name
        Api.Object.Product.imageUrl
        Api.Object.Product.price
        |> SelectionSet.map Product


view : Discount -> Product -> Element msg
view discount ((Product productDetails) as product) =
    Element.row [ Element.spacing 30 ]
        [ Element.image [ Element.width (Element.px 100) ]
            { src = productDetails.imageUrl
            , description = productDetails.name
            }
        , Element.text productDetails.name
        , priceView discount product
        ]


priceView : Discount -> Product -> Element msg
priceView discount (Product productDetails) =
    case Discount.apply discount productDetails.code of
        Just { discountedPrice } ->
            Element.row [ Element.spacing 10 ]
                [ Element.el [ Element.Font.strike ] (Dollars.toString productDetails.price |> Element.text)
                , Dollars.toString discountedPrice |> Element.text
                ]

        Nothing ->
            Dollars.toString productDetails.price |> Element.text
