module Shared.Helpers exposing (onClickWithPreventDefault, with)

import Json.Decode
import Html exposing (..)
import Html.Events exposing (onWithOptions)

import Shared.Types exposing (..)

onClickWithPreventDefault : Bool -> Msg -> Attribute Msg
onClickWithPreventDefault preventDefault msg =
  onWithOptions "click" {
    stopPropagation = False,
    preventDefault = preventDefault
  } (Json.Decode.succeed msg)

{-| Curry a default argument to a function

Before:

  users
  |> (filterByName profile)

After:

  users
  |> with profile filterByName
-}
with : a -> (a -> b -> c) -> b -> c
with a callback b =
  callback a b
