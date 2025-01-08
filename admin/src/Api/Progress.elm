module Api.Progress exposing (fetchProgress)

import Http
import Json.Decode as Decode exposing (Decoder, bool, float, int, string)
import Json.Decode.Pipeline as DP
import Shared.Types exposing (Progress)


fetchProgress : (Result Http.Error (List Progress) -> msg) -> Cmd msg
fetchProgress handler =
    Http.get
        { url = "http://localhost:8005/progress.json"

        -- , url = "https://api.jannejaroosa.fi/responses/"
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
