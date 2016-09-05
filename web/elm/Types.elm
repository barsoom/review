module Types exposing (..)

type Msg
  = SwitchTab Tab
  | UpdateEnvironment String
  | UpdateSettings Settings
  | UpdateEmail String
  | UpdateName String
  | UpdateCommits (List Commit)
  | UpdateCommit Commit
  | ShowCommit Int
  | StartReview CommitChange
  | AbandonReview CommitChange
  | MarkAsReviewed CommitChange
  | MarkAsNew CommitChange

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

type alias Model =
  { commits : List Commit
  , settings : Settings
  , exampleAuthor : String
  , lastClickedCommitId : Int
  , environment : String
  , activeTab : Tab
  }
