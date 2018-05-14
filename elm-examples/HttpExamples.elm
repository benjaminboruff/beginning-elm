module HttpExamples exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (string, list, decodeString, Decoder)


-- Model


type alias Model =
    { nicknames : List String
    , errorMessage : Maybe String
    }


init : ( Model, Cmd msg )
init =
    ( { nicknames = []
      , errorMessage = Nothing
      }
    , Cmd.none
    )



-- View


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick SendHttpRequest ]
            [ text "Get data from the server" ]
        , viewNicknamesOrError model
        ]


viewNicknamesOrError : Model -> Html Msg
viewNicknamesOrError model =
    case model.errorMessage of
        Just message ->
            viewError message

        Nothing ->
            viewNicknames model.nicknames


viewError : String -> Html Msg
viewError errorMessage =
    let
        errorHeading =
            "Couldn't fetch nicknames at this time"
    in
        div []
            [ h3 [] [ text errorHeading ]
            , text ("Error: " ++ errorMessage)
            ]


viewNicknames : List String -> Html Msg
viewNicknames nicknames =
    div []
        [ h3 [] [ text "Old School Main Characters" ]
        , ul [] (List.map viewNickname nicknames)
        ]


viewNickname : String -> Html Msg
viewNickname nickname =
    li [] [ text nickname ]



-- Update


type Msg
    = SendHttpRequest
    | DataReceived (Result Http.Error (List String))


nicknamesDecoder : Decoder (List String)
nicknamesDecoder =
    list string


httpCommand : Cmd Msg
httpCommand =
    nicknamesDecoder
        |> Http.get "http://localhost:5019/nicknames"
        |> Http.send DataReceived


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendHttpRequest ->
            ( model, httpCommand )

        DataReceived (Ok nicknames) ->
            ( { model | nicknames = nicknames }, Cmd.none )

        DataReceived (Err httpError) ->
            ( { model
                | errorMessage = Just (createErrorMessage httpError)
              }
            , Cmd.none
            )


createErrorMessage : Http.Error -> String
createErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "It appears you don't have an internet connection right now"

        Http.BadStatus response ->
            response.status.message

        Http.BadPayload message response ->
            message



-- Subscriptions
-- Main


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
