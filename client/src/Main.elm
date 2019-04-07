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
import Page.ProductDetail
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
    | ProductDetailMsg Page.ProductDetail.Msg


type alias Model =
    { subModel : SubModel
    , navKey : Browser.Navigation.Key
    , route : Route
    }


type SubModel
    = HomeModel Page.Home.Model
    | ProductDetailModel Page.ProductDetail.Model


type alias Flags =
    ()


init : Flags -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url navKey =
    ( { subModel = Tuple.first Page.Home.init |> HomeModel
      , navKey = navKey
      , route = Route.Home
      }
    , Tuple.second Page.Home.init |> Cmd.map HomeMsg
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.subModel ) of
        ( UrlRequested urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External href ->
                    ( model, Browser.Navigation.load href )

        ( UrlChanged url, _ ) ->
            ( { model | route = Route.Product }
            , Cmd.none
            )

        ( HomeMsg homeMsg, HomeModel subModel ) ->
            Page.Home.update homeMsg subModel
                |> updateWith HomeModel HomeMsg model

        ( ProductDetailMsg subMsg, ProductDetailModel subModel ) ->
            Page.ProductDetail.update subMsg subModel
                |> updateWith ProductDetailModel ProductDetailMsg model

        ( _, _ ) ->
            ( model, Cmd.none )


updateWith : (subModel -> SubModel) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith mapModel mapMsg model ( subModel, subCmd ) =
    ( { model | subModel = mapModel subModel }
    , Cmd.map mapMsg subCmd
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
        (case model.subModel of
            HomeModel subModel ->
                Page.Home.view subModel
                    |> Element.map HomeMsg

            ProductDetailModel subModel ->
                Page.ProductDetail.view subModel
                    |> Element.map ProductDetailMsg
        )
            |> Element.layout []
            |> List.singleton
    }
