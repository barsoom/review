module CommitList.Model (Commit, Model) where

type alias Commit =
  { id : Int
  , summary : String
  , gravatarHash : String
  , repository : String
  , authorName : String
  , timestamp : String
  , isReviewed : Bool
  , isBeingReviewed : Bool
  }

type alias Model =
  {
    commits : List Commit
  , lastClickedCommitId : Int
  }
