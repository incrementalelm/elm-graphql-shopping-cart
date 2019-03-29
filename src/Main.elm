module Main exposing (main)

import Api.Enum.DiscountErrorReason as DiscountErrorReason exposing (DiscountErrorReason)
import Api.Object.DiscountedProductInfo
import Api.Query as Query
import Api.Union.DiscountedProductInfoOrError
import Browser
import Discount
import Element exposing (Element)
import Element.Input
import Graphql.Document as Document
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, hardcoded, with)
import Helpers.Main
import RemoteData exposing (RemoteData)


type alias Response =
    Discount.Discount


query : String -> SelectionSet Response RootQuery
query discountCode =
    Query.discountOrError { discountCode = discountCode }
        Discount.selection


makeRequest : String -> Cmd Msg
makeRequest discountCode =
    query discountCode
        |> Graphql.Http.queryRequest "http://localhost:4000/"
        |> Graphql.Http.send (\result -> result |> RemoteData.fromResult |> GotResponse)



-- Elm Architecture Setup


type Msg
    = GotResponse (RemoteData (Graphql.Http.Error Response) Response)
    | ChangedDiscountCode String


type alias Model =
    { discountCode : String
    , discountInfo : RemoteData (Graphql.Http.Error Response) Response
    }


type alias Flags =
    ()


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { discountCode = "", discountInfo = RemoteData.NotAsked }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResponse response ->
            ( { model | discountInfo = response }, Cmd.none )

        ChangedDiscountCode newDiscountCode ->
            ( { model | discountCode = newDiscountCode }, makeRequest newDiscountCode )


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }


view : Model -> Browser.Document Msg
view model =
    { title = "The Elm Shoppe"
    , body =
        Element.row [] [ discountInputView model ]
            |> Element.layout []
            |> List.singleton
    }


discountInputView : Model -> Element Msg
discountInputView model =
    Element.row [ Element.width Element.fill, Element.spacing 20 ]
        [ inputView model
        , discountView model
        ]


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
        , label = Element.Input.labelLeft [] Element.none
        }
