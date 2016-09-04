port module Ports exposing (..)

import Types exposing (Commit, CommitChange, Settings)

port commits : (List Commit -> msg) -> Sub msg
port updatedCommit : (Commit -> msg) -> Sub msg

port environment : (String -> msg) -> Sub msg
port settings : (Settings -> msg) -> Sub msg
port settingsChange : Settings -> Cmd msg
port outgoingCommands : (String, CommitChange) -> Cmd msg
