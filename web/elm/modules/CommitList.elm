module CommitList where

import Html exposing (..)
import String

import CommitList.Update exposing(..)
import CommitList.Model exposing(..)
import CommitList.View exposing(view)

port commits : List Commit
port updatedCommit : Signal Commit

-- publishes events like [ "StartReview", "12" ]
port outgoingCommands : Signal (List String)
port outgoingCommands =
  Signal.map (\action ->
    action |> toString |> String.split(" ")
  ) inbox.signal

main : Signal Html
main =
  Signal.map (view inbox.address) model

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    StartReview id ->
      updateCommitById (\commit -> { commit | isBeingReviewed = True }) id model

    AbandonReview id ->
      updateCommitById (\commit -> { commit | isBeingReviewed = False }) id model

    UpdatedCommit commit ->
      updateCommitById (\_ -> commit) commit.id model

updateCommitById : (Commit -> Commit) -> Int -> Model -> Model
updateCommitById callback id model =
  let
    updateCommit commit =
      if commit.id == id then
        (callback commit)
      else
        commit
  in
     { model | commits = (List.map updateCommit model.commits)}

-- triggers when someone else updates a commit and we receive a websocket push with an update for a commit
updatedCommitActions : Signal Action
updatedCommitActions =
  Signal.map (\commit -> (UpdatedCommit commit)) updatedCommit

actions : Signal Action
actions =
  Signal.merge inbox.signal updatedCommitActions

model =
  let initialModel = { commits = commits }
  in Signal.foldp update initialModel actions
