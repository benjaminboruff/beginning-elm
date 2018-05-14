module Misc exposing (..)

import Types exposing (..)
import RemoteData exposing (WebData)


findPostById : PostId -> WebData (List Post) -> Maybe Post
findPostById postId posts =
    case RemoteData.toMaybe posts of
        Just posts ->
            posts
                |> List.filter (\post -> post.id == postId)
                |> List.head

        Nothing ->
            Nothing
