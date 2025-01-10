module Api.Login exposing (fetchToken, sendLogin)

import Api.Api exposing (buildEndpointUrl)
import Http
import Iso8601 as Iso
import Json.Decode as Decode exposing (Decoder, bool, int, string)
import Json.Decode.Pipeline as DP
import Json.Encode as Encode exposing (Value)
import Shared.Types exposing (Token, User)


fetchToken : User -> (Result Http.Error Token -> msg) -> Cmd msg
fetchToken user handler =
    Http.post
        { url = buildEndpointUrl "auth/login"
        , body = Http.jsonBody (encodeUser user)
        , expect = Http.expectJson handler tokenDecoder
        }


sendLogin : String
sendLogin =
    "moi"


encodeUser : User -> Value
encodeUser user =
    Encode.object [ ( "username", Encode.string user.username ), ( "password", Encode.string user.password ) ]


tokenDecoder : Decoder Token
tokenDecoder =
    Decode.succeed Token
        |> DP.required "access_token" string
        |> DP.required "token_type" string
