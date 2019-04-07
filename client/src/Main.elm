module Main exposing (main)

import Api.Query as Query
import Browser
import Browser.Navigation
import Discount exposing (Discount)
import Element exposing (Element)
import Element.Border
import Element.Events
import Element.Input
import Product exposing (Product)
import RemoteData exposing (RemoteData)
import Request exposing (Response)
import Url exposing (Url)


productsRequest : Cmd Msg
productsRequest =
    Query.products Product.selection
        |> Request.query GotProducts


discountRequest : String -> Cmd Msg
discountRequest discountCode =
    Query.discountOrError { discountCode = discountCode } Discount.selection
        |> Request.query GotResponse



-- Elm Architecture Setup


type Msg
    = GotResponse (Response Discount)
    | GotProducts (Response (List Product.Product))
    | ChangedDiscountCode String
    | ApplyDiscountCode
    | UrlRequested Browser.UrlRequest
    | UrlChanged Url


type alias Model =
    { discountCode : String
    , discountInfo : Response Discount
    , products : Response (List Product.Product)
    , navKey : Browser.Navigation.Key
    }


type alias Flags =
    ()


init : Flags -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url navKey =
    ( { discountCode = ""
      , discountInfo = RemoteData.Success Discount.none
      , products = RemoteData.Loading
      , navKey = navKey
      }
    , productsRequest
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResponse response ->
            ( { model | discountInfo = response }, Cmd.none )

        ChangedDiscountCode newDiscountCode ->
            ( { model | discountCode = newDiscountCode }, Cmd.none )

        GotProducts productsResponse ->
            ( { model | products = productsResponse }, Cmd.none )

        ApplyDiscountCode ->
            ( model, discountRequest model.discountCode )

        UrlRequested urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External href ->
                    ( model, Browser.Navigation.load href )

        UrlChanged url ->
            ( model, Cmd.none )


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }


view : Model -> Browser.Document Msg
view model =
    { title = "The Elm Shoppe"
    , body =
        Element.column [ Element.spacing 15 ]
            [ Element.text "Products"
            , productsView model
            , discountInputView model
            ]
            |> Element.layout []
            |> List.singleton
    }


productsView : Model -> Element Msg
productsView model =
    case RemoteData.map2 Tuple.pair model.discountInfo model.products of
        RemoteData.Success ( discount, products ) ->
            List.map (Product.view discount) products
                |> Element.column []

        RemoteData.Failure error ->
            Element.text <| Debug.toString error

        RemoteData.Loading ->
            Element.text "Loading..."

        RemoteData.NotAsked ->
            Element.text "Not asked..."


discountInputView : Model -> Element Msg
discountInputView model =
    Element.row [ Element.width Element.fill, Element.spacing 20 ]
        [ inputView model
        , applyButton
        , discountView model
        ]


applyButton : Element Msg
applyButton =
    Element.el
        [ Element.Border.width 2
        , Element.padding 10
        , Element.Events.onClick ApplyDiscountCode
        ]
        (Element.text "Apply")


discountView : { model | discountCode : String, discountInfo : RemoteData e Discount.Discount } -> Element msg
discountView { discountCode, discountInfo } =
    case discountInfo of
        RemoteData.NotAsked ->
            Element.text ""

        RemoteData.Loading ->
            Element.text "..."

        RemoteData.Failure e ->
            Element.text "Failed to load"

        RemoteData.Success discount ->
            Discount.view discount


inputView : { a | discountCode : String } -> Element Msg
inputView model =
    Element.Input.text [ Element.width Element.fill ]
        { onChange = ChangedDiscountCode
        , text = model.discountCode
        , placeholder = Nothing
        , label = Element.Input.labelLeft [ Element.centerY ] (Element.text "Discount Code")
        }
