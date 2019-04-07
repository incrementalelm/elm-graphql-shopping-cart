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


type Msg
    = GotProducts (Response (List Product.Product))


type alias Model =
    { products : Response (List Product.Product)
    }


update msg model =
    case msg of
        GotProducts productsResponse ->
            ( { model | products = productsResponse }, Cmd.none )


view model =
    Element.column [ Element.spacing 15 ]
        [ Element.text "Products"
        , productsView model
        ]


init : ( Model, Cmd Msg )
init =
    ( { products = RemoteData.Loading
      }
    , productsRequest
    )


productsView : Model -> Element Msg
productsView model =
    case model.products of
        RemoteData.Success products ->
            Element.none

        -- List.map Product.view products
        --     |> Element.column []
        RemoteData.Failure error ->
            Element.text <| Debug.toString error

        RemoteData.Loading ->
            Element.text "Loading..."

        RemoteData.NotAsked ->
            Element.text "Not asked..."


productsRequest : Cmd Msg
productsRequest =
    Query.products Product.selection
        |> Request.query GotProducts
