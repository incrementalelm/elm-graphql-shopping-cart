module Main exposing (main)

import Api.Query as Query
import Browser
import Browser.Navigation
import Discount exposing (Discount)
import Element exposing (Element)
import Element.Border
import Element.Events
import Element.Input
import Page.Home
import Product exposing (Product)
import RemoteData exposing (RemoteData)
import Request exposing (Response)
import Route exposing (Route)
import Url exposing (Url)



-- Elm Architecture Setup


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url
    | HomeMsg Page.Home.Msg


type alias Model =
    { subModel : Page.Home.Model
    , navKey : Browser.Navigation.Key
    , route : Route
    }


type alias Flags =
    ()


init : Flags -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url navKey =
    ( { subModel = Tuple.first Page.Home.init
      , navKey = navKey
      , route = Route.Home
      }
    , Tuple.second Page.Home.init |> Cmd.map HomeMsg
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequested urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External href ->
                    ( model, Browser.Navigation.load href )

        UrlChanged url ->
            ( { model | route = Route.Product }
            , Cmd.none
            )

        HomeMsg homeMsg ->
            let
                ( updatedSubModel, subMsg ) =
                    Page.Home.update homeMsg model.subModel
            in
            ( { model | subModel = updatedSubModel }
            , subMsg |> Cmd.map HomeMsg
            )


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
        Page.Home.view model.subModel
            |> Element.map HomeMsg
            |> Element.layout []
            |> List.singleton
    }
