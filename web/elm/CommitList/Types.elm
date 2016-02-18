module CommitList.Types (Action (..), Commit, Model) where

type Action
  = NoOp
  | StartReview Int
  | AbandonReview Int
  | MarkAsReviewed Int
  | ShowCommit Int
  | UpdatedCommit Commit

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
  , lastClickedCommitId : Int
  , environment : String
  }
