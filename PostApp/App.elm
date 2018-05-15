module App exposing (main)

import State exposing (init, updateWithStorage)
import View exposing (view)
import Types exposing (..)
import Navigation


main : Program (Maybe (List Post)) Model Msg
main =
    Navigation.programWithFlags LocationChanged
        { init = init
        , view = view
        , update = updateWithStorage
        , subscriptions = \_ -> Sub.none
        }
