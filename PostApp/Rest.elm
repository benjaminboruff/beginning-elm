module Rest
    exposing
        ( fetchPostsCommand
        , updatePostCommand
        , deletePostCommand
        , createPostCommand
        )

import Http
import RemoteData
import Types exposing (..)
import Json.Decode exposing (string, int, list, Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode


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


deletePostCommand : Post -> Cmd Msg
deletePostCommand post =
    deletePostRequest post
        |> Http.send PostDeleted


deletePostRequest : Post -> Http.Request String
deletePostRequest post =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "http://localhost:5019/posts/" ++ (toString post.id)
        , body = Http.emptyBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }


fetchPostsCommand : Cmd Msg
fetchPostsCommand =
    list postDecoder
        |> Http.get "http://localhost:5019/posts"
        |> RemoteData.sendRequest
        |> Cmd.map PostsReceived


updatePostCommand : Post -> Cmd Msg
updatePostCommand post =
    updatePostRequest post
        |> Http.send PostUpdated


updatePostRequest : Post -> Http.Request Post
updatePostRequest post =
    Http.request
        { method = "PATCH"
        , headers = []
        , url = "http://localhost:5019/posts/" ++ (toString post.id)
        , body = Http.jsonBody (postEncoder post)
        , expect = Http.expectJson postDecoder
        , timeout = Nothing
        , withCredentials = False
        }


postEncoder : Post -> Encode.Value
postEncoder post =
    Encode.object
        [ ( "id", Encode.int post.id )
        , ( "title", Encode.string post.title )
        , ( "author", authorEncoder post.author )
        ]


authorEncoder : Author -> Encode.Value
authorEncoder author =
    Encode.object
        [ ( "name", Encode.string author.name )
        , ( "url", Encode.string author.url )
        ]


createPostCommand : Post -> Cmd Msg
createPostCommand post =
    createPostRequest post
        |> Http.send PostCreated


createPostRequest : Post -> Http.Request Post
createPostRequest post =
    Http.request
        { method = "POST"
        , headers = []
        , url = "http://localhost:5019/posts"
        , body = Http.jsonBody (newPostEncoder post)
        , expect = Http.expectJson postDecoder
        , timeout = Nothing
        , withCredentials = False
        }


newPostEncoder : Post -> Encode.Value
newPostEncoder post =
    Encode.object
        [ ( "title", Encode.string post.title )
        , ( "author", authorEncoder post.author )
        ]
