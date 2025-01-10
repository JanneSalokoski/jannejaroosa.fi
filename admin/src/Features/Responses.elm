module Features.Responses exposing (..)

import Api.Responses exposing (fetchResponses)
import Date
import Html exposing (..)
import Html.Attributes exposing (..)
import Shared.Error
import Shared.Types exposing (Response, Token)
import Task
import Time exposing (toHour, toMinute, utc)


type alias Model =
    { responses : List Response
    , loading : Bool
    , error : Maybe String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model [] False Nothing
      -- , Task.perform (\_ -> FetchResponses) (Task.succeed ())
    , Task.perform (\_ -> FetchResponses Nothing) (Task.succeed ())
    )


type Msg
    = FetchResponses (Maybe Token)
    | FetchResponsesSuccess (List Response)
    | FetchResponsesError String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchResponses token ->
            let
                a =
                    Debug.log "Fetching" 1
            in
            ( { model | loading = True, error = Nothing }
            , fetchResponses token
                (\result ->
                    case result of
                        Ok responses ->
                            FetchResponsesSuccess responses

                        Err error ->
                            FetchResponsesError (Shared.Error.toString error)
                )
            )

        FetchResponsesSuccess responses ->
            let
                a =
                    Debug.log "Success" 1
            in
            ( { model | loading = False, responses = responses }, Cmd.none )

        FetchResponsesError error ->
            let
                a =
                    Debug.log "Error" 1
            in
            ( { model | loading = False, error = Just error }, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "Feature", class "Responses" ]
        [ h2 [] [ text "Vastaukset" ]
        , if model.loading then
            div [ class "loading" ] [ text "Loading..." ]

          else
            ul [ class "ItemList", class "responses" ]
                (viewResponseHeaders :: List.map viewResponse model.responses)
        , case model.error of
            Just err ->
                div [ class "error" ] [ text err ]

            Nothing ->
                text ""
        ]



--
-- viewResponse : Response -> Html Msg
-- viewResponse response =
--     li [ class "Response" ]
--         [ span [ class "name" ] [ text response.name ]
--         , span [ class "diet" ] [ text response.diet ]
--         , span [ class "rsvp" ] [ text response.rsvp ]
--         , span [ class "timestamp" ] [ text response.time ]
--         ]
--
--
--


viewResponseHeaders : Html Msg
viewResponseHeaders =
    ul [ class "Response", class "header" ]
        [ li [ class "id" ] [ text "ID" ]
        , li [ class "name" ] [ text "Nimi" ]
        , li [ class "diet" ] [ text "Ruokavalio" ]
        , li [ class "rsvp" ] [ text "Osallistuu" ]
        , li [ class "time" ] [ text "Vastausaika" ]
        ]


formatTime : Time.Posix -> String
formatTime time =
    let
        date =
            Debug.log "date" (Date.fromPosix utc time)
    in
    String.pad 2 '0' (String.fromInt (Date.day date))
        ++ "."
        ++ String.pad 2 '0' (String.fromInt (Date.monthNumber date))
        ++ "."
        ++ String.pad 2 '0' (String.fromInt (Date.year date))
        ++ " "
        ++ String.pad 2 '0' (String.fromInt (toHour utc time))
        ++ ":"
        ++ String.pad 2 '0' (String.fromInt (toMinute utc time))


viewResponse : Response -> Html Msg
viewResponse response =
    ul [ class "Response" ]
        [ li [ class "id" ] [ text (String.fromInt response.id) ]
        , li [ class "name" ] [ text response.name ]
        , li [ class "diet" ] [ text response.diet ]
        , li [ class "rsvp" ]
            [ text
                (if response.rsvp == True then
                    "Osallistuu"

                 else
                    "Ei osallistu"
                )
            ]
        , li [ class "time" ] [ text (formatTime response.time) ]
        ]
