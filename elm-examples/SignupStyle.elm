module SignupStyle exposing (..)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Css exposing (..)
import Css.Colors exposing (white)


headerStyle : Attribute msg
headerStyle =
    css
        [ paddingLeft (cm 3) ]


formStyle : Attribute msg
formStyle =
    css
        [ borderRadius (px 5)
        , backgroundColor (hex "f2f2f2")
        , padding (px 20)
        , width (px 300)
        ]


inputTextStyle : Attribute msg
inputTextStyle =
    css
        [ display block
        , width (px 260)
        , padding2 (px 12) (px 20)
        , margin2 (px 8) (px 0)
        , border (px 0)
        , borderRadius (px 4)
        ]


buttonStyle : Attribute msg
buttonStyle =
    css
        [ width (px 300)
        , backgroundColor (hex "397cd5")
        , color Css.Colors.white
        , padding2 (px 14) (px 20)
        , marginTop (px 10)
        , border (px 0)
        , borderRadius (px 4)
        , fontSize (px 16)
        ]
