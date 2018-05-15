port module PortExamples exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (Value, string, decodeValue)


-- Model


type alias ComplexData =
    { posts : List Post
    , comments : List Comment
    , profile : Profile
    }


type alias Post =
    { id : Int
    , title : String
    , author : Author
    }


type alias Author =
    { name : String
    , url : String
    }


type alias Comment =
    { id : Int
    , body : String
    , postId : Int
    }


type alias Profile =
    { name : String }


type alias Model =
    { dataFromJs : String
    , dataToJs : ComplexData
    , errorMessage : Maybe String
    }


type Msg
    = SendDataToJs
    | ReceivedDataFromJs Value



-- View


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick SendDataToJs ]
            [ text "Send Data to JavaScript" ]
        , br [] []
        , br [] []
        , viewDataFromJsOrError model
        ]


viewDataFromJsOrError : Model -> Html Msg
viewDataFromJsOrError model =
    case model.errorMessage of
        Just message ->
            viewError message

        Nothing ->
            viewDataFromJs model.dataFromJs


viewError : String -> Html Msg
viewError errorMessage =
    let
        errorHeading =
            "Countn't receive data from JavaScript"
    in
        div []
            [ h3 [] [ text errorHeading ]
            , text ("Error: " ++ errorMessage)
            ]


viewDataFromJs : String -> Html Msg
viewDataFromJs data =
    div []
        [ h3 [] [ text "Received the following data from JavaScript" ]
        , text data
        ]



-- Update


port sendData : ComplexData -> Cmd msg


port receiveData : (Value -> msg) -> Sub msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendDataToJs ->
            ( model, sendData model.dataToJs )

        ReceivedDataFromJs value ->
            case decodeValue string value of
                Ok data ->
                    ( { model | dataFromJs = data }, Cmd.none )

                Err error ->
                    ( { model | errorMessage = Just error }, Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( { dataFromJs = ""
      , dataToJs = complexData
      , errorMessage = Nothing
      }
    , Cmd.none
    )


complexData : ComplexData
complexData =
    let
        post1 =
            Author "typicode" "https://github.com/typicode"
                |> Post 1 "json-server"

        post2 =
            Author "indexzero" "https://github.com/indexzero"
                |> Post 2 "http-server"
    in
        { posts = [ post1, post2 ]
        , comments = [ Comment 1 "some comment" 1 ]
        , profile = { name = "typicode" }
        }



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
