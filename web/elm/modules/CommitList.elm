module CommitList where

import Html exposing (..)
import Html.Attributes exposing (..)
--import Html.Events exposing (..)

port commits : List Commit

type alias Commit = {
  id : Int
}

main =
  div [ ] (List.map renderCommit commits)

renderCommit commit =
  div [ class "test-commit" ] [ text (toString commit.id) ]
