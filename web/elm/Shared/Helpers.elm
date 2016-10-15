module Shared.Helpers exposing (onClickWithPreventDefault)

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
