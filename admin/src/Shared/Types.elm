module Shared.Types exposing (Progress, Response)

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
