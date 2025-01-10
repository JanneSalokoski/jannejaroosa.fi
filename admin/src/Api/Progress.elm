module Api.Progress exposing (fetchProgress)

import Api.Api exposing (buildEndpointUrl)
import Http
import Json.Decode as Decode exposing (Decoder, bool, float, int, string)
import Json.Decode.Pipeline as DP
import Shared.Types exposing (Progress, Token)



-- fetchProgress : (Result Http.Error (List Progress) -> msg) -> Cmd msg
-- fetchProgress handler =
--     Http.get
--         { url = buildEndpointUrl "progress/stats"
--         , expect = Http.expectJson handler progressesDecoder
--         }


fetchProgress : Maybe Token -> (Result Http.Error (List Progress) -> msg) -> Cmd msg
fetchProgress token handler =
    let
        accessToken =
            case token of
                Just x ->
                    x.access_token

                Nothing ->
                    ""

        url =
            Debug.log "url" (buildEndpointUrl "progress/stats")

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
        , expect = Http.expectJson handler progressesDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


progressesDecoder : Decoder (List Progress)
progressesDecoder =
    Decode.list progressDecoder


progressDecoder : Decoder Progress
progressDecoder =
    Decode.succeed Progress
        |> DP.required "headline" string
        |> DP.required "amount" int
        |> DP.required "average" float
