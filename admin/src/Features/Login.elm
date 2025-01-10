module Features.Login exposing (..)

import Api.Login exposing (fetchToken)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Shared.Error
import Shared.Types exposing (Token, User)
import Task


type alias Model =
    { user : User
    , token : Maybe Token
    , loading : Bool
    , error : Maybe String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model (User "" "") Nothing False Nothing
    , Cmd.none
    )


type Msg
    = FetchToken
    | FetchTokenSuccess Token
    | FetchTokenError String
    | UsernameChanged String
    | PasswordChanged String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchToken ->
            ( { model | loading = True, error = Nothing }
            , fetchToken model.user
                (\result ->
                    case result of
                        Ok token ->
                            FetchTokenSuccess token

                        Err error ->
                            FetchTokenError (Shared.Error.toString error)
                )
            )

        FetchTokenSuccess token ->
            ( { model | loading = False, token = Just token }, Cmd.none )

        FetchTokenError error ->
            ( { model | loading = False, error = Just error }, Cmd.none )

        UsernameChanged username ->
            let
                user =
                    model.user

                new_user =
                    { user | username = username }
            in
            ( { model | user = new_user }
            , Cmd.none
            )

        PasswordChanged password ->
            let
                user =
                    model.user

                new_user =
                    { user | password = password }
            in
            ( { model | user = new_user }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div [ class "Feature", class "Login" ]
        [ h2 [] [ text "Kirjaudu sisään" ]
        , if model.loading then
            div [ class "loading" ] [ text "Loading..." ]

          else
            Html.form [ class "login", onSubmit FetchToken ]
                [ div [ class "inputBlock" ]
                    [ Html.label [ for "username" ] [ text "Käyttäjä:" ]
                    , Html.input [ type_ "text", name "username", id "username", placeholder "Keijo Käyttäjä", value model.user.username, onInput UsernameChanged ] []
                    ]
                , div [ class "inputBlock" ]
                    [ Html.label [ for "password" ] [ text "Salasana:" ]
                    , Html.input [ type_ "password", name "password", id "password", placeholder "Villisilmä", value model.user.password, onInput PasswordChanged ] []
                    ]
                , div [ class "inputBlock" ]
                    [ Html.input [ type_ "submit", id "submit", value "Kirjaudu sisään" ] [] ]
                ]
        , case model.error of
            Just err ->
                div [ class "error" ] [ text err ]

            Nothing ->
                text ""
        ]
