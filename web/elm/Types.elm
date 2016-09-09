module Types exposing (..)

import Time exposing (Time)

type Msg
  = SwitchTab Tab
  | UpdateEnvironment String
  | UpdateSettings Settings
  | UpdateEmail String
  | UpdateName String
  | UpdateCommits (List Commit)
  | UpdateComments (List Comment)
  | UpdateCommit Commit
  | ShowCommit Int
  | ListMoreCommits Time
  | StartReview CommitChange
  | AbandonReview CommitChange
  | MarkAsReviewed CommitChange
  | MarkAsNew CommitChange
  | LocationChange String
  | UpdateConnectionStatus Bool

type Tab
  = CommitsTab
  | CommentsTab
  | SettingsTab

type alias Settings =
  { name : String
  , email : String
  }

type alias Field =
  { id : String
  , label : String
  , name : String
  , value : String
  , onInput : String -> Msg
  }

type alias CommitChange =
  { id : Int
  , byEmail : String
  }

type alias CommitButton =
  { name : String
  , class : String
  , iconClass : String
  , msg : Msg
  }

type alias Commit =
  { id : Int
  , summary : String
  , repository : String
  , authorName : String
  , authorGravatarHash : String
  , timestamp : String
  , isNew : Bool
  , isReviewed : Bool
  , isBeingReviewed : Bool
  , url : String
  , pendingReviewerGravatarHash : Maybe String
  , pendingReviewerEmail : Maybe String
  , reviewerGravatarHash : Maybe String
  , reviewerEmail : Maybe String
  }

type alias Comment =
  { id : Int
  , timestamp : String
  , commitAuthorName : Maybe String
  , commitAuthorGravatar : Maybe String
  , body : String
  }

type alias Model =
  { commits : List Commit
  , comments: List Comment
  , commitCount : Int
  , settings : Settings
  , exampleAuthor : String
  , lastClickedCommitId : Int
  , commitsToShowCount : Int
  , environment : String
  , activeTab : Tab
  , connected : Connectivity
  }

type Connectivity =
  Unknown
  | Yes
  | No
