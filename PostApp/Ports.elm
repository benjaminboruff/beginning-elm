port module Ports exposing (..)

import Types exposing (..)


port storePosts : List Post -> Cmd msg
