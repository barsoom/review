module CommitList where

import Html exposing (..)
import Html.Attributes exposing (..)
--import Html.Events exposing (..)

port commits : List Commit

type alias Commit =
  { id : Int
  , summary : String
  , gravatarHash : String
  }

main =
  ul [ class "commits-list" ] (List.map renderCommit commits)

renderCommit commit =
  li [ id (commitId commit), class "test-commit" ] [
    a [ class "block-link" ] [
      div [ class "commit-wrapper" ] [
        div [ class "commit-controls" ] [
          div [] [
            button [ class "small start-review" ] [
              i [ class "fa fa-eye" ] [ text "Start review" ]
            ]
          ]
        ]
      , img [ class "commit-avatar", src (avatarUrl commit) ] []
      , div [ class "commit-summary-and-details" ] [
          div [ class "commit-summary test-summary" ] [ text commit.summary ]
        ]
      ]
    ]
  ]

avatarUrl commit =
 "https://secure.gravatar.com/avatar/" ++ commit.gravatarHash ++ "?size=40&amp;rating=x&amp;default=mm"

commitId commit =
  "commit-" ++ toString commit.id
