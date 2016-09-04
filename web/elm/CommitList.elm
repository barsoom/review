port module CommitList exposing (main)

import CommitList.Types exposing (..)
import CommitList.View exposing (view)
import CommitList.Update exposing (update)
import Settings.Types exposing (Settings)

import Html.App as Html
import Html exposing (div, text)
import String

---- API to the outside world (javascript/server) ----

--- receives initial data
port commits : (List Commit -> msg) -> Sub msg
port environment : (String -> msg) -> Sub msg

port outgoingCommands : (String, CommitChange) -> Cmd msg

---- receives updated data
--port updatedCommit : Signal Commit
--port settings : Signal Settings
--
---- publishes events like ("StartReview", { byEmail = "foo@example.com", id = 123 })
--port outgoingCommands : Signal (String, CommitChange)
--port outgoingCommands =
--  inbox.signal
--  |> Signal.map (\action ->
--    case action of
--      StartReview change -> ("StartReview", change)
--      AbandonReview change -> ("AbandonReview", change)
--      MarkAsReviewed change -> ("MarkAsReviewed", change)
--      MarkAsNew change  -> ("MarkAsNew", change)
--      other -> noCommand
--  )
--  |> Signal.filter isOutgoing noCommand
--
--isOutgoing (command) =
--  command /= noCommand
--
--noCommand =
--  ("", { byEmail = "", id = 1 })
--

---- current state and action collection ----

main =
  Html.program
    { init = (initialModel, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \_ ->
      commits UpdateCommits
    }

--model : Signal Model
--model =
--  Signal.foldp update initialModel actions
--
initialModel : Model
initialModel =
  {
    commits = [] --initialCommits
  , settings = { email = "", name = "" }
  , lastClickedCommitId = 0
  --, environment = environment
  }
--
--actions : Signal Action
--actions =
--  Signal.mergeMany [
--    inbox.signal
--  , Signal.map UpdatedCommit updatedCommit
--  , Signal.map UpdateSettings settings
--  ]
--
--inbox : Signal.Mailbox Action
--inbox =
--  Signal.mailbox NoOp
