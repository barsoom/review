port module Ports exposing (..)

import CommitList.Types exposing (Commit, CommitChange)
import Settings.Types exposing (Settings)

port commits : (List Commit -> msg) -> Sub msg
port updatedCommit : (Commit -> msg) -> Sub msg

port environment : (String -> msg) -> Sub msg
port settings : (Settings -> msg) -> Sub msg
port settingsChange : Settings -> Cmd msg
port outgoingCommands : (String, CommitChange) -> Cmd msg
