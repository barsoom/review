module CommitList.Update (Action (..), inbox, model) where

import CommitList.Model exposing(..)
import String

port commits : List Commit
port updatedCommit : Signal Commit

port outgoingCommands : Signal (List String)
port outgoingCommands =
  Signal.map (\action ->
    action |> toString |> String.split(" ")
  ) inbox.signal

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

-- Signals

inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp

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

type Action
  = NoOp
  | StartReview Int
  | AbandonReview Int
  | UpdatedCommit Commit
