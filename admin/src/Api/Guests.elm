module Api.Guests exposing (fetchGuest)

import Api.Api exposing (buildEndpointUrl)
import Http
import Iso8601 as Iso
import Json.Decode as Decode exposing (Decoder, bool, int, string)
import Json.Decode.Pipeline as DP
import Shared.Types exposing (Guest, Token)
import Time exposing (millisToPosix)



-- fetchGuest : (Result Http.Error (List Guest) -> msg) -> Cmd msg
-- fetchGuest handler =
--     Http.get
--         { url = buildEndpointUrl "guests"
--         , expect = Http.expectJson handler guestsDecoder
--         }


fetchGuest : Maybe Token -> (Result Http.Error (List Guest) -> msg) -> Cmd msg
fetchGuest token handler =
    let
        accessToken =
            case token of
                Just x ->
                    x.access_token

                Nothing ->
                    ""

        url =
            Debug.log "guests url" (buildEndpointUrl "guests")

        headers =
            [ Http.header "Authorization" ("Bearer " ++ accessToken)
            , Http.header "Content-Type" "application/json"
            ]
    in
    Http.request
        { method = "GET"
        , headers = headers
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson handler guestsDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


guestsDecoder : Decoder (List Guest)
guestsDecoder =
    Decode.list guestDecoder


guestDecoder : Decoder Guest
guestDecoder =
    Decode.succeed Guest
        |> DP.required "guest_id" int
        |> DP.required "name" string
        |> DP.required "group" string
        |> DP.optional "diet" string ""
        |> DP.required "rsvp" bool
        |> DP.optional "time" Iso.decoder (millisToPosix 0)
