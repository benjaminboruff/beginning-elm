module Signup exposing (..)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (id, type_, class, placeholder, style)
import Html.Styled.Events exposing (onClick, onInput)
import SignupStyle exposing (..)


-- import SignupStyle exposing (..)
-- Model


type alias User =
    { name : String
    , email : String
    , password : String
    , loggedIn : Bool
    }


initialModel : User
initialModel =
    { name = ""
    , email = ""
    , password = ""
    , loggedIn = False
    }



-- Update


type Msg
    = SaveName String
    | SaveEmail String
    | SavePassword String
    | Signup


update : Msg -> User -> User
update message user =
    case message of
        SaveName name ->
            Debug.log "The user is " { user | name = name }

        SaveEmail email ->
            Debug.log "The user is " { user | email = email }

        SavePassword password ->
            Debug.log "The user is " { user | password = password }

        Signup ->
            { user | loggedIn = True }



-- View


view : User -> Html Msg
view user =
    div []
        [ h1 [ headerStyle ] [ text "Sign Up" ]
        , Html.Styled.form
            [ formStyle ]
            [ div []
                [ div []
                    [ text "Name"
                    , input
                        [ id "name"
                        , type_ "text"
                        , inputTextStyle
                        , onInput SaveName
                        ]
                        []
                    ]
                , div []
                    [ text "Email"
                    , input
                        [ id "email"
                        , type_ "email"
                        , inputTextStyle
                        , placeholder "opensource@email.com"
                        , onInput SaveEmail
                        ]
                        []
                    ]
                , div []
                    [ text "Password"
                    , input
                        [ id "password"
                        , type_ "password"
                        , inputTextStyle
                        , onInput SavePassword
                        ]
                        []
                    ]
                , div []
                    [ button
                        [ type_ "submit"
                        , buttonStyle
                        , onClick Signup
                        ]
                        [ text "Create my Account" ]
                    ]
                ]
            ]
        ]


main : Program Never User Msg
main =
    beginnerProgram { model = initialModel, view = view, update = update }
