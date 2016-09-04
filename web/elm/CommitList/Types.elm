module CommitList.Types exposing (Msg (..), Commit, Model, CommitButton, CommitChange)

import Settings.Types exposing (Settings)

type Msg
  = NoOp
  | StartReview CommitChange
  | AbandonReview CommitChange
  | MarkAsReviewed CommitChange
  | MarkAsNew CommitChange
  | ShowCommit Int
  | UpdateCommit Commit
  | UpdateSettings Settings
  | UpdateCommits (List Commit)

type alias CommitChange =
  {
    id : Int
  , byEmail : String
  }

type alias CommitButton =
  {
    name : String
  , class : String
  , iconClass : String
  , msg : Msg
  }

type alias Commit =
  {
    id : Int
  , summary : String
  , authorGravatarHash : String
  , pendingReviewerGravatarHash : String
  , reviewerGravatarHash : String
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
