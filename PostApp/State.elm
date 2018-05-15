module State exposing (..)

import RemoteData exposing (WebData)
import Types exposing (..)
import Rest
    exposing
        ( fetchPostsCommand
        , updatePostCommand
        , deletePostCommand
        , createPostCommand
        )
import Navigation exposing (Location)
import Routing
import Misc exposing (findPostById)
import Ports exposing (..)


tempPostId : PostId
tempPostId =
    -1


emptyPost : Post
emptyPost =
    Author "" ""
        |> Post tempPostId ""


initialModel : WebData (List Post) -> Route -> Model
initialModel posts route =
    { posts = posts
    , currentRoute = route
    , newPost = emptyPost
    }


init : Maybe (List Post) -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
            Routing.extractRoute location

        posts =
            case flags of
                Just listOfPosts ->
                    RemoteData.succeed listOfPosts

                Nothing ->
                    RemoteData.Loading
    in
        ( initialModel posts currentRoute, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchPosts ->
            ( { model | posts = RemoteData.Loading }, fetchPostsCommand )

        PostsReceived response ->
            ( { model | posts = response }, Cmd.none )

        LocationChanged location ->
            ( { model
                | currentRoute = Routing.extractRoute location
              }
            , Cmd.none
            )

        UpdateTitle postId newTitle ->
            updateField postId newTitle setTitle model

        UpdateAuthorName postId newName ->
            updateField postId newName setAuthorName model

        UpdateAuthorUrl postId newUrl ->
            updateField postId newUrl setAuthorUrl model

        SubmitUpdatedPost postId ->
            case findPostById postId model.posts of
                Just post ->
                    ( model, updatePostCommand post )

                Nothing ->
                    ( model, Cmd.none )

        PostUpdated _ ->
            ( model, Cmd.none )

        DeletePost postId ->
            case findPostById postId model.posts of
                Just post ->
                    Debug.log "Found!!!" ( model, deletePostCommand post )

                Nothing ->
                    Debug.log "Not found ..." ( model, Cmd.none )

        PostDeleted _ ->
            ( model, fetchPostsCommand )

        NewPostTitle newTitle ->
            updateNewPost newTitle setTitle model

        NewAuthorName newName ->
            updateNewPost newName setAuthorName model

        NewAuthorUrl newUrl ->
            updateNewPost newUrl setAuthorUrl model

        CreateNewPost ->
            ( model, createPostCommand model.newPost )

        PostCreated (Ok post) ->
            ( { model
                | posts = addNewPost post model.posts
                , newPost = emptyPost
              }
            , Cmd.none
            )

        PostCreated (Err _) ->
            ( model, Cmd.none )


updateWithStorage : Msg -> Model -> ( Model, Cmd Msg )
updateWithStorage msg model =
    let
        ( newModel, commands ) =
            update msg model

        extractedPosts =
            RemoteData.toMaybe newModel.posts
                |> Maybe.withDefault []
    in
        ( newModel
        , Cmd.batch [ commands, storePosts extractedPosts ]
        )


addNewPost : Post -> WebData (List Post) -> WebData (List Post)
addNewPost newPost posts =
    let
        appendPost : List Post -> List Post
        appendPost listOfPosts =
            List.append listOfPosts [ newPost ]
    in
        RemoteData.map appendPost posts


updateNewPost :
    String
    -> (String -> Post -> Post)
    -> Model
    -> ( Model, Cmd Msg )
updateNewPost newValue updateFunction model =
    let
        updatedNewPost =
            updateFunction newValue model.newPost
    in
        ( { model | newPost = updatedNewPost }, Cmd.none )


updateField :
    PostId
    -> String
    -> (String -> Post -> Post)
    -> Model
    -> ( Model, Cmd Msg )
updateField postId newValue updateFunction model =
    let
        updatePost post =
            if post.id == postId then
                updateFunction newValue post
            else
                post

        updatePosts posts =
            List.map updatePost posts

        updatedPosts =
            RemoteData.map updatePosts model.posts
    in
        ( { model | posts = updatedPosts }, Cmd.none )


setTitle : String -> Post -> Post
setTitle newTitle post =
    { post | title = Debug.log "The new title is: " newTitle }


setAuthorName : String -> Post -> Post
setAuthorName newName post =
    let
        oldAuthor =
            post.author
    in
        { post | author = { oldAuthor | name = Debug.log "The new name is: " newName } }


setAuthorUrl : String -> Post -> Post
setAuthorUrl newUrl post =
    let
        oldAuthor =
            post.author
    in
        { post | author = { oldAuthor | url = Debug.log "The new url is: " newUrl } }
