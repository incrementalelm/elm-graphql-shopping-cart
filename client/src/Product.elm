module Product exposing (Detail, Product, Summary, detailSelection, detailView, selection, view)

import Api.Object
import Api.Object.Product
import Api.Scalar
import Discount exposing (Discount)
import Dollars exposing (Dollars)
import Element exposing (Element)
import Element.Font
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import ProductId exposing (ProductId)


type Product extra
    = Product (Internals extra)


type Summary
    = Summary


type Detail
    = Detail DetailInfo


type alias DetailInfo =
    { description : String }


type alias Internals extra =
    { code : Api.Scalar.ProductCode
    , name : String
    , imageUrl : String
    , price : Dollars
    , id : ProductId
    , extra : extra
    }


selection : SelectionSet (Product Summary) Api.Object.Product
selection =
    SelectionSet.succeed Summary
        |> baseSelection


baseSelection : SelectionSet extra Api.Object.Product -> SelectionSet (Product extra) Api.Object.Product
baseSelection extraSelection =
    SelectionSet.map6 Internals
        Api.Object.Product.code
        Api.Object.Product.name
        Api.Object.Product.imageUrl
        Api.Object.Product.price
        Api.Object.Product.id
        extraSelection
        |> SelectionSet.map Product


detailSelection : SelectionSet.SelectionSet (Product Detail) Api.Object.Product
detailSelection =
    Api.Object.Product.description
        |> SelectionSet.map DetailInfo
        |> SelectionSet.map Detail
        |> baseSelection


view : Discount -> Product Summary -> Element msg
view discount ((Product productDetails) as product) =
    Element.row [ Element.spacing 30 ]
        [ Element.image [ Element.width (Element.px 100) ]
            { src = productDetails.imageUrl
            , description = productDetails.name
            }
        , Element.text productDetails.name
        , priceView discount product
        ]
        |> ProductId.linkTo productDetails.id []


detailView : Product Detail -> Element msg
detailView ((Product productDetails) as product) =
    Element.row [ Element.spacing 30 ]
        [ Element.image [ Element.width (Element.px 250) ]
            { src = productDetails.imageUrl
            , description = productDetails.name
            }
        , Element.text productDetails.name
        , priceView Discount.none product
        ]


priceView : Discount -> Product extra -> Element msg
priceView discount (Product productDetails) =
    case Discount.apply discount productDetails.code of
        Just { discountedPrice } ->
            Element.row [ Element.spacing 10 ]
                [ Element.el [ Element.Font.strike ] (Dollars.toString productDetails.price |> Element.text)
                , Dollars.toString discountedPrice |> Element.text
                ]

        Nothing ->
            Dollars.toString productDetails.price |> Element.text
