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
    = Product Api.Scalar.ProductCode String String


selection : SelectionSet.SelectionSet Product Api.Object.Product
selection =
    SelectionSet.map3 Product
        Api.Object.Product.code
        Api.Object.Product.name
        Api.Object.Product.imageUrl


view : Product -> Element msg
view (Product (Api.Scalar.ProductCode rawCode) productName imageUrl) =
    Element.row [ Element.spacing 30 ]
        [ Element.image [ Element.width (Element.px 200) ] { src = imageUrl, description = productName }
        , Element.text productName
        ]
