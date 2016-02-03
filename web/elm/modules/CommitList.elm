module CommitList where

import Html exposing (..)
import Html.Attributes exposing (..)
--import Html.Events exposing (..)

port commits : List Commit

type alias Commit =
  { id : Int
  , summary : String
  }

main =
  div [ ] (List.map renderCommit commits)

renderCommit commit =
  div [ id ("commit-" ++ toString commit.id), class "test-commit" ] [ text (toString commit.id) ]
