module CommitList.Update (update) where

import CommitList.Types exposing (..)

update : Action -> Model -> Model
update action model =
  case action of
    NoOp -> model

    -- no local changes so you know if you are in sync
    -- should work fine as long as network speeds are resonable
    StartReview change -> model
    AbandonReview change -> model
    MarkAsReviewed change -> model
    MarkAsNew change -> model

    UpdatedCommit commit ->
      -- triggers when someone else updates a commit and we receive a websocket push with an update for a commit
      updateCommitById (\_ -> commit) commit.id model

    ShowCommit id ->
      { model | lastClickedCommitId = id }

    UpdateSettings settings ->
      { model | settings = settings }

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
