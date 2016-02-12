module CommitList.Types (Action (..), Commit, Model) where

type Action
  = NoOp
  | StartReview Int
  | AbandonReview Int
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
  , isReviewed : Bool
  , isBeingReviewed : Bool
  , url : String
  }

type alias Model =
  {
    commits : List Commit
  , lastClickedCommitId : Int
  }
