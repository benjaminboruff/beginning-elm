module EventListener exposing (..)

import Html exposing (..)
import Keyboard
import Mouse


-- Model


type alias Model =
    Int


init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )



-- View


view : Model -> Html Msg
view model =
    div []
        [ text (toString model) ]



-- Update


type Msg
    = KeyPressed Keyboard.KeyCode
    | MouseClicked Mouse.Position


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyPressed _ ->
            ( model + 1, Cmd.none )

        MouseClicked _ ->
            ( model - 1, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Keyboard.presses KeyPressed
        , Mouse.clicks MouseClicked
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
