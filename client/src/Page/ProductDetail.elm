module Page.ProductDetail exposing (Model, Msg, init, update, view)

import Api.Query as Query
import Discount exposing (Discount)
import Element exposing (Element)
import Element.Border
import Element.Events
import Element.Input
import Product exposing (Product)
import RemoteData exposing (RemoteData)
import Request exposing (Response)
import Scalar exposing (ProductId)


type Msg
    = GotProduct (Response (Maybe (Product Product.Detail)))


type alias Model =
    { products : Response (Maybe (Product Product.Detail))
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotProduct productsResponse ->
            ( { model | products = productsResponse }, Cmd.none )


view model =
    Element.column [ Element.spacing 15 ]
        [ productsView model
        ]


init : ProductId -> ( Model, Cmd Msg )
init productId =
    ( { products = RemoteData.Loading }
    , productsRequest productId
    )


productsView : Model -> Element Msg
productsView model =
    case model.products of
        RemoteData.Success maybeProduct ->
            case maybeProduct of
                Just foundProduct ->
                    Product.detailView foundProduct

                Nothing ->
                    Element.text "Product not found..."

        RemoteData.Failure error ->
            Element.text <| Debug.toString error

        RemoteData.Loading ->
            Element.text "Loading..."

        RemoteData.NotAsked ->
            Element.text "Not asked..."


productsRequest : ProductId -> Cmd Msg
productsRequest id =
    Query.product { id = id } Product.detailSelection
        |> Request.query GotProduct
