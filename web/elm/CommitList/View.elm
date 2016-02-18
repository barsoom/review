module CommitList.View (view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy)
import Date exposing (..)
import Date.Format exposing (..)
import Signal exposing (Address)

import CommitList.Types exposing (..)

view address model =
  ul [ class "commits-list" ] (List.map (lazyRenderCommit address model) model.commits)

-- TODO: figure out if this actually works, the Debug.log is called
--       for each commit even if only one has changed
lazyRenderCommit : Address Action -> Model -> Commit -> Html
lazyRenderCommit address model commit =
  lazy (renderCommit address model) commit

renderCommit : Address Action -> Model -> Commit -> Html
renderCommit address model commit =
  --let _ = Debug.log "commit" commit.id in
  li [ id (commitId commit), (commitClassList model commit) ] [
    a [ class "block-link", href (commitUrl model commit) ] [
      div [ class "commit-wrapper", onClick address (ShowCommit commit.id)  ] [
        div [ class "commit-controls" ] (renderButtons address model commit)
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
            , span [ class "test-timestamp" ] [ text (formattedTime commit.timestamp) ]
            ]
          ]
        ]
      ]
    ]
  ]

-- don't link to github in tests since that makes testing difficult
commitUrl model commit =
  if model.environment /= "test" then commit.url else "#"

renderButtons : Address Action -> Model -> Commit -> List Html
renderButtons address model commit =
  if commit.isReviewed then
    [ ] -- todo
  else if commit.isBeingReviewed then -- todo should be isNew
    [
      commitButton address {
        name = "Abandon review"
      , class = "abandon-review"
      , iconClass = "fa-eye-slash"
      , action = (AbandonReview commit.id)
      }
    , commitButton address {
        name = "Mark as reviewed"
      , class = "mark-as-reviewed"
      , iconClass = "fa-eye-slash"
      , action = (MarkAsReviewed commit.id)
      }
    ]
  else
    [
      commitButton address {
        name = "Start review"
      , class = "start-review"
      , iconClass = "fa-eye"
      , action = (StartReview commit.id)
      }
    ]

commitButton : Address Action -> CommitButton -> Html
commitButton address commitButton =
  button [ class ("small test-button" ++ " " ++ commitButton.class), onClick address commitButton.action ] [
    i [ class ("fa" ++ " " ++ commitButton.iconClass) ] [ text commitButton.name ]
  ]

commitClassList : Model -> Commit -> Attribute
commitClassList model commit =
  classList [
    ("commit", True)

  , ("your-last-clicked", model.lastClickedCommitId == commit.id)

  , ("is-being-reviewed", commit.isBeingReviewed)
  , ("is-reviewed", commit.isReviewed)

  , ("test-is-new", commit.isNew)
  , ("test-is-being-reviewed", commit.isBeingReviewed)
  , ("test-is-reviewed", commit.isReviewed)
  , ("test-commit", True)
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
