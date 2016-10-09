module Shared.CompletedBadge exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import VirtualDom exposing (Node)

view : String -> Node a
view action =
  p [ class "nothing-left-to-review-or-resolve" ] [
    i [ class "fa fa-trophy fa-2x trophy" ] []
  , span [ class "text" ] [
      strong [] [ text <| "Nothing left to " ++ action ++ "!" ]
    , text " Good job."
    ]
  ]
