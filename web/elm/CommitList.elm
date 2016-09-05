module CommitList exposing (view)

import Types exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Lazy exposing (lazy)
import Date
import Date.Format
import String
import VirtualDom exposing (Node, Property)

view : Model -> Node Msg
view model =
  let
    commits = commitsToShow model
  in
    ul [ class "commits-list" ] (List.map (lazyRenderCommit model) commits)

commitsToShow : Model -> List Commit
commitsToShow model =
  model.commits |> List.take(model.commitsToShowCount)

-- TODO: figure out if this actually works, the Debug.log is called
--       for each commit even if only one has changed
lazyRenderCommit : Model -> Commit -> Node Msg
lazyRenderCommit model commit =
  lazy (renderCommit model) commit

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
      , msg = (commitChangeMsg StartReview model commit)
      }
    ]
  else if commit.isBeingReviewed then
    [
      commitButton {
        name = "Abandon review"
      , class = "abandon-review"
      , iconClass = "fa-eye-slash"
      , msg = (commitChangeMsg AbandonReview model commit)
      }
    , commitButton {
        name = "Mark as reviewed"
      , class = "mark-as-reviewed"
      , iconClass = "fa-eye-slash"
      , msg = (commitChangeMsg MarkAsReviewed model commit)
      }
    , img [ class "commit-reviewer-avatar test-reviewer", src (avatarUrl commit.pendingReviewerGravatarHash), reviewerDataAttribute(commit.pendingReviewerEmail) ] []
    ]
  else if commit.isReviewed then
    [
      commitButton {
        name = "Mark as new"
      , class = "mark-as-new"
      , iconClass = "fa-eye-slash"
      , msg = (commitChangeMsg MarkAsNew model commit)
      }
    , img [ class "commit-reviewer-avatar test-reviewer", src (avatarUrl commit.reviewerGravatarHash), reviewerDataAttribute(commit.reviewerEmail) ] []
    ]
  else
    -- This should never happen
    []

reviewerDataAttribute : Maybe String -> Attribute a
reviewerDataAttribute email =
  attribute "data-test-reviewer-email" (Maybe.withDefault "" email)

commitChangeMsg : (CommitChange -> a) -> Model -> Commit -> a
commitChangeMsg msg model commit =
  msg { byEmail = model.settings.email, id = commit.id }

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

formattedTime : String -> String
formattedTime timestamp =
  timestamp
  |> Date.fromString
  |> Result.withDefault (Date.fromTime 0)
  |> Date.Format.format "%a %e %b at %H:%M" -- E.g. Wed 3 Feb at 15:14

avatarUrl : Maybe String -> String
avatarUrl gravatarHash =
  let
    hash = (Maybe.withDefault "" gravatarHash)
  in
    "https://secure.gravatar.com/avatar/" ++ hash ++ "?size=40&amp;rating=x&amp;default=mm"

commitId : Commit -> String
commitId commit =
  "commit-" ++ toString commit.id
