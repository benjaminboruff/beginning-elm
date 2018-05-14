module App exposing (main)

import State exposing (init, update)
import View exposing (view)
import Types exposing (..)
import Navigation


main : Program Never Model Msg
main =
    Navigation.program LocationChanged
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
