module Api.Api exposing (buildEndpointUrl)


debug : Bool
debug =
    False


apiUrl : String
apiUrl =
    if debug then
        "http://localhost:8000/"

    else
        "https://api.jannejaroosa.fi/"


buildEndpointUrl : String -> String
buildEndpointUrl endpoint =
    if debug then
        apiUrl ++ endpoint ++ "/"

    else
        apiUrl ++ endpoint ++ "/"
