module Api.Progress exposing (fetchProgress)

import Api.Api exposing (buildEndpointUrl)
import Http
import Json.Decode as Decode exposing (Decoder, bool, float, int, string)
import Json.Decode.Pipeline as DP
import Shared.Types exposing (Progress)


fetchProgress : (Result Http.Error (List Progress) -> msg) -> Cmd msg
fetchProgress handler =
    Http.get
        { url = buildEndpointUrl "progress"
        , expect = Http.expectJson handler progressesDecoder
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
