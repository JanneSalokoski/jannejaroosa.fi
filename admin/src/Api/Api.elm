module Api.Api exposing (buildEndpointUrl)


debug : Bool
debug =
    False


apiUrl : String
apiUrl =
    if debug then
        "http://127.0.0.1:8005/"

    else
        "https://api.jannejaroosa.fi/"


buildEndpointUrl : String -> String
buildEndpointUrl endpoint =
    if debug then
        apiUrl ++ endpoint ++ ".json"

    else
        apiUrl ++ endpoint
