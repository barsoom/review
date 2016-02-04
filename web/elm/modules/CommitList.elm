module CommitList where

import Html exposing (..)
import Html.Attributes exposing (..)
--import Html.Events exposing (..)
import Date exposing (..)
import Date.Format exposing (..)

port commits : List Commit

main : Html
main =
  ul [ class "commits-list" ] (List.map renderCommit commits)

renderCommit : Commit -> Html
renderCommit commit =
  li [ id (commitId commit), commitClassList(commit) ] [
    a [ class "block-link" ] [
      div [ class "commit-wrapper" ] [
        div [ class "commit-controls" ] [
          button [ class "small start-review" ] [
            i [ class "fa fa-eye" ] [ text "Start review" ]
          ]
        ]
      , img [ class "commit-avatar", src (avatarUrl commit) ] []
      , div [ class "commit-summary-and-details" ] [
          div [ class "commit-summary test-summary" ] [ text commit.summary ]
        , div [ class "commit-details" ] [
            text " in "
          , strong [] [ text commit.repository ]
          , span [ class "by-author" ] [
              text " by "
            , strong [] [ text commit.authorName ]
            , text " on "
            , span [] [ text (formattedTime commit.timestamp) ]
            ]
          ]
        ]
      ]
    ]
  ]

commitClassList : Commit -> Attribute
commitClassList commit =
  classList [
    ("commit", True)
  , ("is-reviewed", commit.isReviewed)
  ]

formattedTime : String -> String
formattedTime timestamp =
  timestamp
  |> Date.fromString
  |> Result.withDefault (Date.fromTime 0)
  |> Date.Format.format "%a %e %b at %H:%M" -- E.g. Wed 3 Feb at 15:14

avatarUrl : Commit -> String
avatarUrl commit =
 "https://secure.gravatar.com/avatar/" ++ commit.gravatarHash ++ "?size=40&amp;rating=x&amp;default=mm"

commitId : Commit -> String
commitId commit =
  "commit-" ++ toString commit.id

type alias Commit =
  { id : Int
  , summary : String
  , gravatarHash : String
  , repository : String
  , authorName : String
  , timestamp : String
  , isReviewed : Bool
  }
