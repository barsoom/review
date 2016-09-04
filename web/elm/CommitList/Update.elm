module CommitList.Update exposing (update)

import CommitList.Types exposing (..)
import Ports exposing (outgoingCommands)

update : Msg -> Model -> (Model, Cmd a)
update msg model =
  case msg of
    NoOp -> (model, Cmd.none)

    -- no local changes so you know if you are in sync
    -- should work fine as long as network speeds are resonable
    StartReview change    -> (model, pushEvent "StartReview" change)
    AbandonReview change  -> (model, pushEvent "AbandonReview" change)
    MarkAsReviewed change -> (model, pushEvent "MarkAsReviewed" change)
    MarkAsNew change      -> (model, pushEvent "MarkAsNew" change)

    UpdateCommit commit ->
      -- triggers when someone else updates a commit and we receive a websocket push with an update for a commit
      (updateCommitById (\_ -> commit) commit.id model, Cmd.none)

    UpdateCommits commits ->
      ({ model | commits = commits }, Cmd.none)

    ShowCommit id ->
      ({ model | lastClickedCommitId = id }, Cmd.none)

    UpdateSettings settings ->
      ({ model | settings = settings }, Cmd.none)

pushEvent : String -> CommitChange -> Cmd a
pushEvent name change =
  outgoingCommands (name, change)

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
