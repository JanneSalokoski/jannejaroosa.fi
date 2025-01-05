module Main exposing (..)

import Browser
import Date exposing (fromPosix)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Iso8601 as Iso
import Json.Decode as Decode exposing (Decoder, bool, int, string)
import Json.Decode.Pipeline as DP
import Time exposing (Posix, toHour, toMinute, toSecond, utc)



-- Main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Model


type alias Response =
    { id : Int
    , name : String
    , diet : String
    , rsvp : Bool
    , time : Posix
    }


type State
    = Failure String
    | Loading
    | Success (List Response)


type alias Model =
    { state : State
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Loading
    , Http.get
        { url = "https://api.jannejaroosa.fi/responses/"
        , expect = Http.expectJson Loaded responsesDecoder
        }
    )



-- Update


type Msg
    = NoOp
    | Loaded (Result Http.Error (List Response))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Cmd.none
            )

        Loaded (Ok responses) ->
            ( { model | state = Success responses }, Cmd.none )

        Loaded (Err error) ->
            ( { model | state = Failure (Debug.toString error) }, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- View


view : Model -> Html Msg
view model =
    div [ id "App" ]
        [ viewResponses model
        ]


viewResponses : Model -> Html Msg
viewResponses model =
    case model.state of
        Success responses ->
            div [ class "responses" ]
                [ h2 [] [ text "Vastaukset" ]
                , div [ class "table" ] (viewResponseHeaders :: List.map viewResponse responses)
                ]

        Failure error ->
            div [ class "responses" ] [ text ("Error: " ++ error) ]

        Loading ->
            div [ class "responses" ] [ text "Loading..." ]


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


responsesDecoder : Decoder (List Response)
responsesDecoder =
    Decode.list responseDecoder


responseDecoder : Decoder Response
responseDecoder =
    Decode.succeed Response
        |> DP.required "response_id" int
        |> DP.required "name" string
        |> DP.required "diet" string
        |> DP.required "rsvp" bool
        |> DP.required "time" Iso.decoder
