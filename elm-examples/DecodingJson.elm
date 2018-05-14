module DecodingJson exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (href)
import Http
import Json.Decode exposing (string, int, list, Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import RemoteData exposing (WebData)


-- Model


type alias Author =
    { name : String
    , url : String
    }


type alias Post =
    { id : Int
    , title : String
    , author : Author
    }


type alias Model =
    { posts : WebData (List Post) }



-- View


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick FetchPosts ]
            [ text "Refresh posts" ]
        , viewPostsOrError model
        ]


viewPostsOrError : Model -> Html Msg
viewPostsOrError model =
    case model.posts of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            h3 [] [ text "Loading ..." ]

        RemoteData.Success posts ->
            viewPosts posts

        RemoteData.Failure httpError ->
            viewError (createErrorMessage httpError)



-- Errors


viewError : String -> Html Msg
viewError errorMessage =
    let
        errorHeading =
            "Couldn't fetch data at this time."
    in
        div []
            [ h3 [] [ text errorHeading ]
            , text ("Error: " ++ errorMessage)
            ]


createErrorMessage : Http.Error -> String
createErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "It appears you don't have an Internet connection right now."

        Http.BadStatus response ->
            response.status.message

        Http.BadPayload message response ->
            message



-- Posts


viewPosts : List Post -> Html Msg
viewPosts posts =
    div []
        [ h3 [] [ text "Posts" ]
        , table []
            ([ viewTableHeader ] ++ List.map viewPost posts)
        ]


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "ID" ]
        , th []
            [ text "Title" ]
        , th []
            [ text "Author" ]
        ]


viewPost : Post -> Html Msg
viewPost post =
    tr []
        [ td []
            [ text (toString post.id) ]
        , td []
            [ text post.title ]
        , td []
            [ a [ href post.author.url ] [ text post.author.name ] ]
        ]



-- Update


type Msg
    = FetchPosts
    | PostsReceived (WebData (List Post))


authorDecoder : Decoder Author
authorDecoder =
    decode Author
        |> required "name" string
        |> required "url" string


postDecoder : Decoder Post
postDecoder =
    decode Post
        |> required "id" int
        |> required "title" string
        |> required "author" authorDecoder


fetchPostsCommand : Cmd Msg
fetchPostsCommand =
    list postDecoder
        |> Http.get "http://localhost:5019/posts"
        |> RemoteData.sendRequest
        |> Cmd.map PostsReceived


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchPosts ->
            ( { model | posts = RemoteData.Loading }, fetchPostsCommand )

        PostsReceived response ->
            ( { model | posts = response }, Cmd.none )



-- Main


init : ( Model, Cmd Msg )
init =
    ( { posts = RemoteData.Loading }, fetchPostsCommand )


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
