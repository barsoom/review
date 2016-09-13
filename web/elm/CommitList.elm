module CommitList exposing (view)

import SharedTypes exposing (..)
import Avatar exposing (avatarUrl)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import String
import Formatting exposing (formattedTime)
import VirtualDom exposing (Node, Property)
import Change exposing (changeMsg)

view : Model -> Node Msg
view model =
  let
    commits = commitsToShow model
  in
    ul [ class "commits-list" ] (List.map (renderCommit model) commits)

commitsToShow : Model -> List Commit
commitsToShow model =
  model.commits |> List.take(model.commitsToShowCount)

renderCommit : Model -> Commit -> Node Msg
renderCommit model commit =
  li [ id (commitId commit), (commitClassList model commit) ] [
    a [ class "block-link", href (commitUrl model commit) ] [
      div [ class "commit-wrapper", onClick (ShowCommit commit.id)  ] [
        div [ class "commit-controls" ] (renderButtons model commit)
      , img [ class "commit-avatar", src (avatarUrl (Just commit.authorGravatarHash)) ] []
      , div [ class "commit-summary-and-details" ] [
          div [ class "commit-summary test-summary" ] [ text commit.summary ]
        , renderCommitDetails commit
        ]
      ]
    ]
  ]

renderCommitDetails : Commit -> Node a
renderCommitDetails commit =
  div [ class "commit-details" ] [
    text " in "
  , strong [] [ text commit.repository ]
  , span [ class "by-author" ] [
      text " by "
    , strong [] [ text commit.authorName ]
    , text " on "
    , span [ class "test-timestamp" ] [ text (formattedTime commit.timestamp) ]
    ]
  ]

-- don't link to github in tests since that makes testing difficult
commitUrl: Model -> Commit -> String
commitUrl model commit =
  if model.environment == "test" || model.environment == "dev" then
     "#"
  else
    commit.url

renderButtons : Model -> Commit -> List (Node Msg)
renderButtons model commit =
  if commit.isNew then
    [
      commitButton {
        name = "Start review"
      , class = "start-review"
      , iconClass = "fa-eye"
      , msg = (changeMsg StartReview model commit)
      }
    ]
  else if commit.isBeingReviewed then
    [
      commitButton {
        name = "Abandon review"
      , class = "abandon-review"
      , iconClass = "fa-eye-slash"
      , msg = (changeMsg AbandonReview model commit)
      }
    , commitButton {
        name = "Mark as reviewed"
      , class = "mark-as-reviewed"
      , iconClass = "fa-eye-slash"
      , msg = (changeMsg MarkAsReviewed model commit)
      }
    , img [ class "commit-reviewer-avatar test-reviewer", src (avatarUrl commit.pendingReviewerGravatarHash), reviewerDataAttribute(commit.pendingReviewerEmail) ] []
    ]
  else if commit.isReviewed then
    [
      commitButton {
        name = "Mark as new"
      , class = "mark-as-new"
      , iconClass = "fa-eye-slash"
      , msg = (changeMsg MarkAsNew model commit)
      }
    , img [ class "commit-reviewer-avatar test-reviewer", src (avatarUrl commit.reviewerGravatarHash), reviewerDataAttribute(commit.reviewerEmail) ] []
    ]
  else
    -- This should never happen
    []

reviewerDataAttribute : Maybe String -> Attribute a
reviewerDataAttribute email =
  attribute "data-test-reviewer-email" (Maybe.withDefault "" email)

commitButton : CommitButton -> Node Msg
commitButton commitButton =
  button [ class ("small test-button" ++ " " ++ commitButton.class), onClick commitButton.msg ] [
    i [ class ("fa" ++ " " ++ commitButton.iconClass) ] [ text commitButton.name ]
  ]

commitClassList : Model -> Commit -> Property a
commitClassList model commit =
  classList [
    ("commit", True)

  , ("your-last-clicked", model.lastClickedCommitId == commit.id)
  , ("authored-by-you", authoredByYou model commit)

  , ("is-being-reviewed", commit.isBeingReviewed)
  , ("is-reviewed", commit.isReviewed)

  , ("test-is-new", commit.isNew)
  , ("test-is-being-reviewed", commit.isBeingReviewed)
  , ("test-is-reviewed", commit.isReviewed)
  , ("test-commit", True)
  , ("test-authored-by-you", authoredByYou model commit)
  ]

authoredByYou : Model -> Commit -> Bool
authoredByYou model commit =
  String.contains model.settings.name commit.authorName

commitId : Commit -> String
commitId commit =
  "commit-" ++ toString commit.id
