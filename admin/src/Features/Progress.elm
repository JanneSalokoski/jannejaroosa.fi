module Features.Progress exposing (..)

import Api.Progress exposing (fetchProgress)
import Html exposing (..)
import Html.Attributes exposing (..)
import Round
import Shared.Error
import Shared.Types exposing (Progress)
import Task


type alias Model =
    { progress : List Progress
    , loading : Bool
    , error : Maybe String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model [] False Nothing
    , Task.perform (\_ -> FetchProgress) (Task.succeed ())
    )


type Msg
    = FetchProgress
    | FetchProgressSuccess (List Progress)
    | FetchProgressError String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchProgress ->
            ( { model | loading = True, error = Nothing }
            , fetchProgress
                (\result ->
                    case result of
                        Ok progress ->
                            FetchProgressSuccess progress

                        Err error ->
                            FetchProgressError (Shared.Error.toString error)
                )
            )

        FetchProgressSuccess progress ->
            ( { model | loading = False, progress = progress }, Cmd.none )

        FetchProgressError error ->
            ( { model | loading = False, error = Just error }, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "Feature", class "Progress" ]
        [ h2 [] [ text "Seuranta" ]
        , if model.loading then
            div [ class "loading" ] [ text "Loading..." ]

          else
            ul [ class "ItemList", class "progress" ]
                (viewProgressHeaders
                    :: List.map viewProgress model.progress
                )
        , case model.error of
            Just err ->
                div [ class "error" ] [ text err ]

            Nothing ->
                text ""
        ]


viewProgressHeaders : Html Msg
viewProgressHeaders =
    ul [ class "Progress", class "header" ]
        [ li [ class "headline" ] [ text "Otsikko" ]
        , li [ class "amount" ] [ text "Katsottu" ]
        , li [ class "time" ] [ text "Saavuttamisaika" ]
        ]


viewProgress : Progress -> Html Msg
viewProgress progress =
    ul [ class "Progress" ]
        [ li [ class "headline" ] [ text progress.headline ]
        , li [ class "amount" ] [ text (String.fromInt progress.amount) ]
        , li [ class "time" ] [ text (Round.round 2 progress.average ++ "ms") ]
        ]
