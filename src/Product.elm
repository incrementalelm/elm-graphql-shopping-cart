module Product exposing (Product, selection, view)

import Api.Object
import Api.Object.DiscountedProductInfo
import Api.Object.Product
import Api.Scalar
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
    }


selection : SelectionSet.SelectionSet Product Api.Object.Product
selection =
    SelectionSet.map3 Details
        Api.Object.Product.code
        Api.Object.Product.name
        Api.Object.Product.imageUrl
        |> SelectionSet.map Product


view : Product -> Element msg
view (Product product) =
    Element.row [ Element.spacing 30 ]
        [ Element.image [ Element.width (Element.px 200) ] { src = product.imageUrl, description = product.name }
        , Element.text product.name
        ]
