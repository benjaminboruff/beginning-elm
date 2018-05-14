module RandomNumber exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Random exposing (..)


-- Model


type alias Model =
    Int


init : ( Model, Cmd msg )
init =
    ( 0, Cmd.none )



-- View


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick GenerateRandomNumber ] [ text "Generate Random Number" ]
        , p [ style [ ( "margin", "1cm" ) ] ] [ text (toString model) ]
        ]



-- Update


type Msg
    = GenerateRandomNumber
    | NewRandomNumber Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GenerateRandomNumber ->
            ( model, Random.generate NewRandomNumber (Random.int 0 100) )

        NewRandomNumber number ->
            ( number, Cmd.none )


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }
