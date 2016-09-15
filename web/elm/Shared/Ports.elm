port module Shared.Ports exposing (..)

import Shared.Types exposing (Commit, Comment, Change)
import Settings.Types exposing (Settings)

-- 100% of the communication with JS goes tough these

-- Incomming (sent by JS, subscribed to in Elm)
port commits : (List Commit -> msg) -> Sub msg
port comments : (List Comment -> msg) -> Sub msg
port environment : (String -> msg) -> Sub msg
port connectionStatus : (Bool -> msg) -> Sub msg

-- Incomming and outgoing (sent by Elm, subscribed to in JS)
port settings : (Settings -> msg) -> Sub msg
port settingsChange : Settings -> Cmd msg

port updatedCommit : (Commit -> msg) -> Sub msg
port outgoingCommands : (String, Change) -> Cmd msg

port location : (String -> msg) -> Sub msg
port navigate : String -> Cmd msg
