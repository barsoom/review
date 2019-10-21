module Shared.Types exposing (..)

import Time exposing (Time)
import Settings.Types exposing (SettingsMsg, Settings)


type Msg
    = SwitchTab Tab
    | UpdateEnvironment String
    | UpdateSettings Settings
    | UpdateCommits (List Commit)
    | UpdateComments (List Comment)
    | AddOrUpdateCommit Commit
    | AddOrUpdateComment Comment
    | ShowCommit Int
    | StoreCurrentTime Time
    | ListMoreCommits Time
    | AnimateInReviewLink Time
    | StartReview Change
    | AbandonReview Change
    | MarkAsReviewed Change
    | MarkAsNew Change
    | MarkCommentAsResolved Change
    | MarkCommentAsNew Change
    | LocationChange String
    | UpdateConnectionStatus Bool
    | StoreLastClickedCommentId Int
    | FocusCommitById Int
    | ChangeSettings SettingsMsg


type Tab
    = CommitsTab
    | CommentsTab
    | SettingsTab


type alias Change =
    { id : Int
    , byEmail : String
    }


type alias CommitButton =
    { name : String
    , class : String
    , iconClass : String
    , msg : Msg
    , openCommitOnGithub : Bool
    }


type alias Commit =
    { id : Int
    , summary : String
    , repository : String
    , timestamp : String
    , reviewStartedTimestamp : Maybe String
    , isNew : Bool
    , isReviewed : Bool
    , isBeingReviewed : Bool
    , url : String
    , authorName : Maybe String
    , authorGravatarHash : Maybe String
    , pendingReviewerGravatarHash : Maybe String
    , pendingReviewerEmail : Maybe String
    , reviewerGravatarHash : Maybe String
    , reviewerEmail : Maybe String
    }


type alias Comment =
    { id : Int
    , timestamp : String
    , resolved : Bool
    , body : String
    , threadIdentifier : String
    , url : String
    , authorGravatar : Maybe String
    , authorName : Maybe String
    , commitAuthorName : Maybe String
    , commitAuthorGravatar : Maybe String
    , commitSummary : Maybe String
    , resolverGravatar : Maybe String
    , resolverEmail : Maybe String
    }


type alias Identifyable a =
    { a | id : Int }


type alias Model =
    { commits : List Commit
    , comments : List Comment
    , commentsToShow : List Comment
    , commitCount : Int
    , settings : Settings
    , lastClickedCommitId : Int
    , lastClickedCommentId : Int
    , commitsToShowCount : Int
    , environment : String
    , activeTab : Tab
    , connected : Connectivity
    , inReviewByYouLinkColorIndex : Int
    , inReviewByYouLinkColors : List Int
    , currentTime : Time
    }


type Connectivity
    = Unknown
    | Yes
    | No
