module Api.Responses exposing (fetchResponses)

import Api.Api exposing (buildEndpointUrl)
import Http
import Iso8601 as Iso
import Json.Decode as Decode exposing (Decoder, bool, int, string)
import Json.Decode.Pipeline as DP
import Shared.Types exposing (Response)
import Time exposing (Posix, toHour, toMinute, toSecond, utc)


fetchResponses : (Result Http.Error (List Response) -> msg) -> Cmd msg
fetchResponses handler =
    let
        url =
            Debug.log "url" (buildEndpointUrl "responses")
    in
    Http.get
        { url = url
        , expect = Http.expectJson handler responsesDecoder
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
