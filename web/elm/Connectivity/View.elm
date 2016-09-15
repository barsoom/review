module Connectivity.View exposing (view)

import Shared.Types exposing (..)

import VirtualDom exposing (Node)
import Html exposing (div, text)
import Html.Attributes exposing (class)

view : Model -> Node a
view model =
  case model.connected of
    Unknown ->
      div [ class "connected connected--unknown" ] [ text "Initializing..." ]
    Yes ->
      div [ class "connected connected--yes" ] [ text "Connected" ]
    No ->
      div [ class "connected connected--no" ] [ text "Attempting to reconnect..." ]
