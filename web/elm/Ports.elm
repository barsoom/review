port module Ports exposing (..)

import Types exposing (Commit, CommitChange, Settings)

-- 100% of the communication with JS goes tough these

-- Incomming (sent by JS, subscribed to in Elm)
port commits : (List Commit -> msg) -> Sub msg
port updatedCommit : (Commit -> msg) -> Sub msg
port environment : (String -> msg) -> Sub msg
port settings : (Settings -> msg) -> Sub msg

-- Outgoing (sent by Elm, subscribed to in JS)
port settingsChange : Settings -> Cmd msg
port outgoingCommands : (String, CommitChange) -> Cmd msg
