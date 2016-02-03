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
  ul [ class "commits-list" ] (List.map renderCommit commits)

renderCommit commit =
  li [ id ("commit-" ++ toString commit.id), class "test-commit" ] [
    a [ class "block-link" ] [
      div [ class "commit-wrapper" ] [
        div [ class "commit-controls" ] []
      , img [ class "commit-avatar", src "" ] []
      , div [ class "commit-summary-and-details" ] [
          div [ class "commit-summary test-summary" ] [ text commit.summary ]
        ]
      ]
    ]
  ]
