module Main exposing (..)

import Browser
import Features.Progress as Progress
import Features.Responses as Responses
import Html exposing (Html)
import Html.Attributes exposing (class)
import Shared.Types exposing (Progress, Response)


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
    }


type Msg
    = ResponsesMsg Responses.Msg
    | ProgressMsg Progress.Msg


init : () -> ( Model, Cmd Msg )
init _ =
    let
        ( responsesModel, responsesCmd ) =
            Responses.init ()

        ( progressModel, progressCmd ) =
            Progress.init ()
    in
    ( Model responsesModel progressModel
    , Cmd.batch [ Cmd.map ResponsesMsg responsesCmd, Cmd.map ProgressMsg progressCmd ]
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


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    Html.div
        [ class "app" ]
        [ Html.map ResponsesMsg (Responses.view model.responsesModel)
        , Html.map ProgressMsg (Progress.view model.progressModel)
        ]
