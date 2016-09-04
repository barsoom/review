module CommitList exposing (main)

import CommitList.Types exposing (..)
import CommitList.View exposing (view)
import CommitList.Update exposing (update)
import Ports exposing (..)

import Html.App as Html
--import String

---- API to the outside world (javascript/server) ----

---- receives updated data
--port updatedCommit : Signal Commit
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

main : Program Never
main =
  Html.program
    { init = (initialModel, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \_ ->
      [ commits UpdateCommits
      , settings UpdateSettings
      ] |> Sub.batch
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
  , environment = "unknown"
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
