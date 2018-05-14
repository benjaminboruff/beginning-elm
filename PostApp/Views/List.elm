module Views.List exposing (view)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Http
import RemoteData


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick FetchPosts ]
            [ text "Refresh posts" ]
        , br [] []
        , br [] []
        , a [ href "/posts/new" ]
            [ text "Create new post" ]
        , viewPostsOrError model
        ]


viewPostsOrError : Model -> Html Msg
viewPostsOrError model =
    case model.posts of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            div []
                [ text "Loading ..." ]

        RemoteData.Success posts ->
            viewPosts posts

        RemoteData.Failure httpError ->
            viewError (createErrorMessage httpError)


viewError : String -> Html Msg
viewError errorMessage =
    let
        errorHeading =
            "Couldn't fetch data at this time."
    in
        div []
            [ h3 [] [ text errorHeading ]
            , text errorMessage
            ]


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
    let
        postPath =
            "/posts/" ++ (toString post.id)
    in
        tr []
            [ td []
                [ text (toString post.id) ]
            , td []
                [ text post.title ]
            , td []
                [ a [ href post.author.url ] [ text post.author.name ] ]
            , td []
                [ a [ href postPath ] [ text "Edit" ]
                ]
            , td []
                [ button [ onClick (DeletePost post.id) ]
                    [ text "Delete" ]
                ]
            ]


createErrorMessage : Http.Error -> String
createErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "It appears you don't have an  Internet connection right now."

        Http.BadStatus response ->
            response.status.message

        Http.BadPayload message response ->
            message
