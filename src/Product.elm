module Product exposing (Product, selection, view)

import Api.Object
import Api.Object.DiscountedProductInfo
import Api.Object.Product
import Api.Scalar
import Discount exposing (Discount)
import Element exposing (Element)
import Element.Input
import Graphql.SelectionSet as SelectionSet
import RemoteData exposing (RemoteData)


type Product
    = Product Details


type alias Details =
    { code : Api.Scalar.ProductCode
    , name : String
    , imageUrl : String
    , price : Int
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
view discount (Product product) =
    Element.row [ Element.spacing 30 ]
        [ Element.image [ Element.width (Element.px 200) ] { src = product.imageUrl, description = product.name }
        , Element.text product.name
        , "$" ++ String.fromInt product.price |> Element.text
        ]
