-- Inlined this code from https://github.com/lukewestby/elm-string-interpolate
-- to get things working in Elm 0.17. That library in turn depends on a console
-- test runner that isn't 0.17 compatible at the time of writing and I'm trying
-- to limit the number of yaks I shave today :)


module String.Interpolate exposing (interpolate)

{-| String.Interpolate provides a convenient method `interpolate` for injecting
values into a string. This can be useful for i18n of apps and construction of
complex strings in views.

@docs interpolate
-}

import String exposing (dropLeft, dropRight, toInt)
import Array exposing (Array, fromList, get)
import Regex exposing (replace, regex, Match, Regex)


{-| Inject other strings into a string in the order they appear in a List
  interpolate "{0} {2} {1}" ["hello", "!!", "world"]
  "{0} {2} {1}" `interpolate` ["hello", "!!", "world"]
-}
interpolate : String -> List String -> String
interpolate string args =
    let
        asArray =
            fromList args
    in
        replace Regex.All interpolationRegex (applyInterpolation asArray) string


interpolationRegex : Regex
interpolationRegex =
    regex "\\{\\d+\\}"


applyInterpolation : Array String -> Match -> String
applyInterpolation replacements match =
    let
        ordinalString =
            ((dropLeft 1) << (dropRight 1)) match.match

        ordinal =
            toInt ordinalString
    in
        case ordinal of
            Err message ->
                ""

            Ok value ->
                case get value replacements of
                    Nothing ->
                        ""

                    Just replacement ->
                        replacement
