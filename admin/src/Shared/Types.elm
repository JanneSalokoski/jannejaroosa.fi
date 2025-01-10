module Shared.Types exposing (Guest, Progress, Response, Token, User)

import Time exposing (Posix)


type alias Response =
    { id : Int
    , name : String
    , diet : String
    , rsvp : Bool
    , time : Posix
    }


type alias Progress =
    { headline : String
    , amount : Int
    , average : Float
    }


type alias Guest =
    { id : Int
    , name : String
    , group : String
    , diet : String
    , rsvp : Bool
    , time : Posix
    }


type alias Token =
    { access_token : String
    , token_type : String
    }


type alias User =
    { username : String
    , password : String
    }
