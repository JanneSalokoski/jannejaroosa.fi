module Api.Responses exposing (fetchResponses)

import Api.Api exposing (buildEndpointUrl)
import Http
import Iso8601 as Iso
import Json.Decode as Decode exposing (Decoder, bool, int, string)
import Json.Decode.Pipeline as DP
import Shared.Types exposing (Response, Token)
import Time exposing (Posix, toHour, toMinute, toSecond, utc)


fetchResponses : Maybe Token -> (Result Http.Error (List Response) -> msg) -> Cmd msg
fetchResponses token handler =
    let
        accessToken =
            case token of
                Just x ->
                    x.access_token

                Nothing ->
                    ""

        url =
            Debug.log "url" (buildEndpointUrl "responses")

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
        , expect = Http.expectJson handler responsesDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


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
