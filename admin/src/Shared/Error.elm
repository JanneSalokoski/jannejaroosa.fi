module Shared.Error exposing (toString)

import Http


toString : Http.Error -> String
toString error =
    case error of
        Http.BadUrl str ->
            "Bad Url: " ++ str

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "NetworkError"

        Http.BadStatus code ->
            "Bad Status: " ++ String.fromInt code

        Http.BadBody str ->
            "Bad Body: " ++ str
