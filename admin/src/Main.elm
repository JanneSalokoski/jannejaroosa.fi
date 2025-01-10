module Main exposing (..)

import Api.Responses exposing (fetchResponses)
import Browser
import Features.Guests as Guests
import Features.Login as Login
import Features.Progress as Progress
import Features.Responses as Responses
import Html exposing (Html)
import Html.Attributes exposing (class)
import Shared.Types exposing (Guest, Progress, Response, Token, User)
import Task


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Model =
    { responsesModel : Responses.Model
    , progressModel : Progress.Model
    , guestsModel : Guests.Model
    , loginModel : Login.Model
    }


type Msg
    = ResponsesMsg Responses.Msg
    | ProgressMsg Progress.Msg
    | GuestsMsg Guests.Msg
    | LoginMsg Login.Msg


init : () -> ( Model, Cmd Msg )
init _ =
    let
        ( responsesModel, responsesCmd ) =
            Responses.init ()

        ( progressModel, progressCmd ) =
            Progress.init ()

        ( guestsModel, guestsCmd ) =
            Guests.init ()

        ( loginModel, loginCmd ) =
            Login.init ()
    in
    ( Model responsesModel progressModel guestsModel loginModel
    , Cmd.batch [ Cmd.map ResponsesMsg responsesCmd, Cmd.map ProgressMsg progressCmd, Cmd.map GuestsMsg guestsCmd, Cmd.map LoginMsg loginCmd ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ResponsesMsg responsesMsg ->
            let
                ( newResponsesModel, responsesCmd ) =
                    Responses.update responsesMsg model.responsesModel
            in
            ( { model | responsesModel = newResponsesModel }
            , Cmd.map ResponsesMsg responsesCmd
            )

        ProgressMsg progressMsg ->
            let
                ( newProgressModel, progressCmd ) =
                    Progress.update progressMsg model.progressModel
            in
            ( { model | progressModel = newProgressModel }
            , Cmd.map ProgressMsg progressCmd
            )

        GuestsMsg guestsMsg ->
            let
                ( newGuestsModel, guestsCmd ) =
                    Guests.update guestsMsg model.guestsModel
            in
            ( { model | guestsModel = newGuestsModel }
            , Cmd.map GuestsMsg guestsCmd
            )

        LoginMsg loginMsg ->
            let
                ( newLoginModel, loginCmd ) =
                    Login.update loginMsg model.loginModel

                isLoggedIn =
                    case newLoginModel.token of
                        Just _ ->
                            True

                        Nothing ->
                            False

                reloadCmds =
                    if isLoggedIn then
                        Cmd.batch
                            [ Cmd.map ResponsesMsg (Task.perform (\_ -> Responses.FetchResponses newLoginModel.token) (Task.succeed ()))
                            , Cmd.map ProgressMsg (Task.perform (\_ -> Progress.FetchProgress newLoginModel.token) (Task.succeed ()))
                            , Cmd.map GuestsMsg (Task.perform (\_ -> Guests.FetchGuest newLoginModel.token) (Task.succeed ()))
                            ]

                    else
                        Cmd.none
            in
            ( { model | loginModel = newLoginModel }
            , Cmd.batch
                [ Cmd.map LoginMsg loginCmd
                , reloadCmds
                ]
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    Html.div
        [ class "app" ]
        [ Html.map LoginMsg (Login.view model.loginModel)
        , Html.map GuestsMsg (Guests.view model.guestsModel)
        , Html.map ProgressMsg (Progress.view model.progressModel)
        , Html.map ResponsesMsg (Responses.view model.responsesModel)
        ]
