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
    , averageRating : Float
    , extra : extra
    }


selection : SelectionSet (Product Summary) Api.Object.Product
selection =
    SelectionSet.succeed Summary
        |> baseSelection


baseSelection : SelectionSet extra Api.Object.Product -> SelectionSet (Product extra) Api.Object.Product
baseSelection extraSelection =
    SelectionSet.map7 Internals
        Api.Object.Product.code
        Api.Object.Product.name
        Api.Object.Product.imageUrl
        Api.Object.Product.price
        Api.Object.Product.id
        Api.Object.Product.averageRating
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


starRating : Float -> Element msg
starRating rating =
    List.map
        (\currentStar ->
            if round rating >= currentStar then
                filledStar

            else
                emptyStar
        )
        [ 1, 2, 3, 4, 5 ]
        |> Element.row [ Element.Font.color (Element.rgb255 255 175 0) ]


filledStar =
    Element.text "★"


emptyStar =
    Element.text "☆"


detailView : Product Detail -> Element msg
detailView ((Product productDetails) as product) =
    Element.row [ Element.spacing 30, Element.width Element.fill ]
        [ Element.image [ Element.width (Element.px 250) ]
            { src = productDetails.imageUrl
            , description = productDetails.name
            }
        , Element.column [ Element.spacing 50 ]
            [ Element.row [ Element.spaceEvenly, Element.width Element.fill ]
                [ Element.text productDetails.name
                , priceView Discount.none product
                ]
            , productDetails.extra |> (\(Detail detail) -> detail.description) |> Element.text
            , starRating productDetails.averageRating
            ]
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
