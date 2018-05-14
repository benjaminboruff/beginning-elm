module Rocket exposing (..)

import Html exposing (Html, text)
import Regex
import MyList exposing (..)
import List exposing (isEmpty)


escapeEarth : Float -> Float -> String -> String
escapeEarth velocity speed fuelStatus =
    let
        escapeVelocityInKmPerSec =
            11.186

        orbitalSpeedInKmPerSec =
            7.67

        whereToLand fuelStatus =
            if fuelStatus == "low" then
                "Land on droneship"
            else
                "Land on launchpad"
    in
        if velocity > escapeVelocityInKmPerSec then
            "Godspeed"
        else if speed == orbitalSpeedInKmPerSec then
            "Stay in orbit"
        else
            whereToLand fuelStatus


speed : Float -> Float -> Float
speed distance time =
    distance / time


time : number -> number -> number
time startTime endTime =
    endTime - startTime



-- view model =
--     div [ class "jumbotron" ]
--         [ h1 [] [ text "Rocketman!" ]
--         , div [] [ text whatToDo ]
--         ]
-- main =
--     Html.text (escapeEarth 11 (speed 7.67 (time 2 3)))


weekday : Int -> String
weekday dayInNumber =
    case dayInNumber of
        0 ->
            "Sunday"

        1 ->
            "Monday"

        2 ->
            "Tuesday"

        3 ->
            "Wednesday"

        4 ->
            "Thursday"

        5 ->
            "Friday"

        6 ->
            "Saturday"

        _ ->
            "Unknown day"


hashtag : Int -> String
hashtag dayInNumber =
    case weekday dayInNumber of
        "Sunday" ->
            "#Sinday"

        "Monday" ->
            "#MondayBlues"

        "Tuesday" ->
            "#TakeMeBackTuesday"

        "Wednesday" ->
            "#HumpDay"

        "Thursday" ->
            "#ThrowbackThursday"

        "Friday" ->
            "#FlashbackFriday"

        "Saturday" ->
            "#Caturday"

        _ ->
            "#Whatever"


palindrome : String -> String
palindrome word =
    let
        testString =
            String.join "" (String.words (String.join " " (String.split ", " (String.toLower word))))
    in
        toString (testString == String.reverse testString)


isValid : Char -> Bool
isValid =
    \c -> c /= '-'


descending : String -> String -> Order
descending a b =
    case compare a b of
        LT ->
            GT

        GT ->
            LT

        EQ ->
            EQ


evilometer : String -> String -> Order
evilometer name1 name2 =
    case ( name1, name2 ) of
        ( "Joffrey", "Ramsay" ) ->
            LT

        ( "Joffrey", "Night King" ) ->
            LT

        ( "Ramsay", "Joffrey" ) ->
            GT

        ( "Ramsay", "Night King" ) ->
            LT

        ( "Night King", "Joffrey" ) ->
            GT

        ( "Night King", "Ramsay" ) ->
            GT

        _ ->
            GT


validateEmail : String -> ( String, String )
validateEmail email =
    let
        emailPattern =
            Regex.regex "\\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}\\b"

        isValid =
            Regex.contains emailPattern email
    in
        if isValid then
            ( "Valid email", "green" )
        else
            ( "Invalid email", "red" )


multiplier : Int
multiplier =
    2


scores : List Int
scores =
    [ 316, 320, 312, 370, 337, 318, 314 ]


doubleScores : List Int -> List Int
doubleScores scores =
    List.map (\x -> x * multiplier) scores


scoresLessThan320 : List Int -> List Int
scoresLessThan320 scores =
    List.filter isLessThan320 scores


isLessThan320 : Int -> Bool
isLessThan320 score =
    score < 320


addOne : number -> number
addOne x =
    x + 1


guardiansWithShortNames : List String -> Int
guardiansWithShortNames guardians =
    guardians
        |> List.map String.length
        |> List.filter (\x -> x < 6)
        |> List.length


add : Int -> Int -> Int
add x y =
    x + y


type Greeting a
    = Howdy
    | Hola
    | Namaste String
    | NumericalHi Int Int



-- sayHello : Greeting -> String
-- sayHello greeting =
--     case greeting of
--         Howdy ->
--             "How y'all doin'?"
--         Hola ->
--             "Hola amigo!"
--         Namaste message ->
--             message
--         NumericalHi value1 value2 ->
--             value1 + value2 |> toString


signUp : String -> String -> Result String String
signUp email age =
    case String.toInt age of
        Err message ->
            Err message

        Ok age ->
            let
                emailPattern =
                    Regex.regex "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}\\b"

                isValidEmail =
                    Regex.contains emailPattern email
            in
                if age < 13 then
                    Err "You need to be at least 13 years old to sign up."
                else if isValidEmail then
                    Ok "Your account has been created successfully!"
                else
                    Err "You entered an invalid email."


type alias Character =
    { name : String
    , age : Maybe Int
    }


sansa : Character
sansa =
    { name = "Sansa"
    , age = Just 19
    }


arya : Character
arya =
    { name = "Arya"
    , age = Nothing
    }


getAdultAge : Character -> Maybe Int
getAdultAge character =
    case character.age of
        Nothing ->
            Nothing

        Just age ->
            if age >= 18 then
                Just age
            else
                Nothing


list1 : MyList a
list1 =
    Empty


list2 : MyList number
list2 =
    Node 9 Empty


list3 : List a
list3 =
    []


main : Html msg
main =
    List.isEmpty list3
        |> toString
        |> text
