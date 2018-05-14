module Types exposing (..)

import RemoteData exposing (WebData)
import Navigation exposing (Location)
import Http


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
    { posts : WebData (List Post)
    , currentRoute : Route
    , newPost : Post
    }


type alias PostId =
    Int


type Msg
    = FetchPosts
    | PostsReceived (WebData (List Post))
    | LocationChanged Location
    | UpdateTitle PostId String
    | UpdateAuthorName PostId String
    | UpdateAuthorUrl PostId String
    | SubmitUpdatedPost PostId
    | PostUpdated (Result Http.Error Post)
    | DeletePost PostId
    | PostDeleted (Result Http.Error String)
    | NewPostTitle String
    | NewAuthorName String
    | NewAuthorUrl String
    | CreateNewPost
    | PostCreated (Result Http.Error Post)


type Route
    = PostsRoute
    | PostRoute Int
    | NotFoundRoute
    | NewPostRoute
