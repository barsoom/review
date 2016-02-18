module CommitList.Update (update) where

import CommitList.Types exposing (..)

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    StartReview id ->
      updateCommitById (\commit -> { commit | isBeingReviewed = True }) id model

    AbandonReview id ->
      updateCommitById (\commit -> { commit | isBeingReviewed = False, isNew = True }) id model

    MarkAsReviewed id ->
      updateCommitById (\commit -> { commit | isReviewed = True }) id model

    UpdatedCommit commit ->
      -- triggers when someone else updates a commit and we receive a websocket push with an update for a commit
      updateCommitById (\_ -> commit) commit.id model

    ShowCommit id ->
      { model | lastClickedCommitId = id }

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
