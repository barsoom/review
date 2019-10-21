module Settings.Types exposing (..)


type alias Settings =
    { name : String
    , email : String
    , showCommentsYouWrote : Bool
    , showCommentsOnOthers : Bool
    , showResolvedComments : Bool
    , showAllReviewedCommits : Bool
    }


type SettingsMsg
    = UpdateShowCommentsYouWrote Bool
    | UpdateShowResolvedComments Bool
    | UpdateShowCommentsOnOthers Bool
    | ToggleShowAllReviewedCommits
    | UpdateEmail String
    | UpdateName String


type alias Field =
    { id : String
    , label : String
    , name : String
    , value : String
    , onInput : String -> SettingsMsg
    }
