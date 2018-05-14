port module PortExamples exposing (..)

import Html exposing (..)
import Html.Events exposing (..)


-- Model


type alias Model =
    String


type Msg
    = SendDataToJs
    | ReceivedDataFromJs Model



-- View


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick SendDataToJs ]
            [ text "Send Data to JavaScript" ]
        , br [] []
        , br [] []
        , text ("Data received from JavaScript: " ++ model)
        ]



-- Update


port sendData : String -> Cmd msg


port receiveData : (Model -> msg) -> Sub msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendDataToJs ->
            ( model, sendData "Hello JavaScript!" )

        ReceivedDataFromJs data ->
            ( data, Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( "", Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    receiveData ReceivedDataFromJs


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
