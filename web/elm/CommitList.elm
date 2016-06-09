module CommitList exposing (main)

import CommitList.Types exposing (..)
import CommitList.View exposing (view)
import CommitList.Update exposing (update)
import Settings.Types exposing (Settings)

import Html exposing (..)
import String


---- API to the outside world (javascript/server) ----

--- receives initial data
port initialCommits : List Commit
port environment : String

-- receives updated data
port updatedCommit : Signal Commit
port settings : Signal Settings

-- publishes events like ("StartReview", { byEmail = "foo@example.com", id = 123 })
port outgoingCommands : Signal (String, CommitChange)
port outgoingCommands =
  inbox.signal
  |> Signal.map (\action ->
    case action of
      StartReview change -> ("StartReview", change)
      AbandonReview change -> ("AbandonReview", change)
      MarkAsReviewed change -> ("MarkAsReviewed", change)
      MarkAsNew change  -> ("MarkAsNew", change)
      other -> noCommand
  )
  |> Signal.filter isOutgoing noCommand

isOutgoing (command) =
  command /= noCommand

noCommand =
  ("", { byEmail = "", id = 1 })


---- current state and action collection ----

main : Signal Html
main =
  Signal.map (view inbox.address) model

model : Signal Model
model =
  Signal.foldp update initialModel actions

initialModel : Model
initialModel =
  {
    commits = initialCommits
  , settings = { email = "", name = "" }
  , lastClickedCommitId = 0
  , environment = environment
  }

actions : Signal Action
actions =
  Signal.mergeMany [
    inbox.signal
  , Signal.map UpdatedCommit updatedCommit
  , Signal.map UpdateSettings settings
  ]

inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp
