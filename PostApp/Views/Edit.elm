module Views.Edit exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Types exposing (..)


view : Post -> Html Msg
view post =
    div []
        [ a [ href "/posts" ] [ text "Back" ]
        , h3 [] [ text "Edit Post" ]
        , editForm post
        ]


editForm : Post -> Html Msg
editForm post =
    Html.form []
        [ div []
            [ text "Title"
            , br [] []
            , input
                [ type_ "text"
                , value post.title
                , onInput (UpdateTitle post.id)
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Author Name"
            , br [] []
            , input
                [ type_ "text"
                , value post.author.name
                , onInput (UpdateAuthorName post.id)
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Author URL"
            , br [] []
            , input
                [ type_ "text"
                , value post.author.url
                , onInput (UpdateAuthorUrl post.id)
                ]
                []
            ]
        , br [] []
        , div []
            [ button [ onClick (SubmitUpdatedPost post.id) ]
                [ text "Submit" ]
            ]
        ]
