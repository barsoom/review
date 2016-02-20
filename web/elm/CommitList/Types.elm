module CommitList.Types (Action (..), Commit, Model, CommitButton) where

import Settings.Types exposing (Settings)

type Action
  = NoOp
  | StartReview Int
  | AbandonReview Int
  | MarkAsReviewed Int
  | MarkAsNew Int
  | ShowCommit Int
  | UpdatedCommit Commit
  | UpdateSettings Settings

type alias CommitButton =
  {
    name : String
  , class : String
  , iconClass : String
  , action : Action
  }

type alias Commit =
  {
    id : Int
  , summary : String
  , gravatarHash : String
  , repository : String
  , authorName : String
  , timestamp : String
  , isNew : Bool
  , isReviewed : Bool
  , isBeingReviewed : Bool
  , url : String
  }

type alias Model =
  {
    commits : List Commit
  , settings : Settings
  , lastClickedCommitId : Int
  , environment : String
  }
