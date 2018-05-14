module Views.New exposing (view)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (href, type_)
import Html.Events exposing (onClick, onInput)


view : Html Msg
view =
    div []
        [ a [ href "/posts" ] [ text "Back" ]
        , h3 [] [ text "Create New Post" ]
        , newPostForm
        ]


newPostForm : Html Msg
newPostForm =
    Html.form []
        [ div []
            [ text "Title" ]
        , br [] []
        , input
            [ type_ "text"
            , onInput NewPostTitle
            ]
            []
        , br [] []
        , br [] []
        , div []
            [ text "Author Name" ]
        , br [] []
        , input
            [ type_ "text"
            , onInput NewAuthorName
            ]
            []
        , br [] []
        , br [] []
        , div []
            [ text "Author URL" ]
        , br [] []
        , input
            [ type_ "text"
            , onInput NewAuthorUrl
            ]
            []
        , br [] []
        , br [] []
        , button [ onClick CreateNewPost ]
            [ text "Submit" ]
        ]
