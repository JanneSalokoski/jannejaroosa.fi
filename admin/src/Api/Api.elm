module Api.Api exposing (buildEndpointUrl)


debug : Bool
debug =
    True


apiUrl : String
apiUrl =
    if debug then
        "http://127.0.0.1:8005/"

    else
        "https://api.jannejaroosa.fi/"


buildEndpointUrl : String -> String
buildEndpointUrl endpoint =
    let
        a =
            Debug.log "url" apiUrl
    in
    if debug then
        apiUrl ++ endpoint ++ ".json"

    else
        apiUrl ++ endpoint
