module Features.Guests exposing (..)

import Api.Guests exposing (fetchGuest)
import Date
import Html exposing (..)
import Html.Attributes exposing (..)
import Shared.Error
import Shared.Types exposing (Guest, Token)
import Task
import Time exposing (toHour, toMinute, utc)


type alias Model =
    { progress : List Guest
    , loading : Bool
    , error : Maybe String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model [] False Nothing
    , Task.perform (\_ -> FetchGuest Nothing) (Task.succeed ())
    )


type Msg
    = FetchGuest (Maybe Token)
    | FetchGuestSuccess (List Guest)
    | FetchGuestError String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchGuest token ->
            ( { model | loading = True, error = Nothing }
            , fetchGuest token
                (\result ->
                    case result of
                        Ok progress ->
                            FetchGuestSuccess progress

                        Err error ->
                            FetchGuestError (Shared.Error.toString error)
                )
            )

        FetchGuestSuccess progress ->
            ( { model | loading = False, progress = progress }, Cmd.none )

        FetchGuestError error ->
            ( { model | loading = False, error = Just error }, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "Feature", class "Guest" ]
        [ h2 [] [ text "Vieraat" ]
        , if model.loading then
            div [ class "loading" ] [ text "Loading..." ]

          else
            ul [ class "ItemList", class "guest" ]
                (viewGuestHeaders
                    :: List.map viewGuest model.progress
                )
        , case model.error of
            Just err ->
                div [ class "error" ] [ text err ]

            Nothing ->
                text ""
        ]


viewGuestHeaders : Html Msg
viewGuestHeaders =
    ul [ class "Guest", class "header" ]
        [ li [ class "guest_id" ] [ text "#" ]
        , li [ class "name" ] [ text "Nimi" ]
        , li [ class "group" ] [ text "Seurue" ]
        , li [ class "diet" ] [ text "Ruokavalio" ]
        , li [ class "rsvp" ] [ text "Osallistuu" ]
        , li [ class "time" ] [ text "Ilmoittatumisaika" ]
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


viewGuest : Guest -> Html Msg
viewGuest guest =
    ul [ class "Guest" ]
        [ li [ class "guest_id" ] [ text (String.fromInt guest.id) ]
        , li [ class "name" ] [ text guest.name ]
        , li [ class "group" ] [ text guest.group ]
        , li [ class "diet" ] [ text guest.diet ]
        , li [ class "rsvp" ]
            [ text
                (if guest.rsvp then
                    "Kyllä"

                 else
                    "Ei"
                )
            ]
        , li [ class "time" ] [ text (formatTime guest.time) ] -- todo: display time properly
        ]
