module CommitList where

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

-- receives updated commit data
port updatedCommit : Signal Commit
port settings : Signal Settings

-- publishes events like [ "StartReview", "12" ]
port outgoingCommands : Signal (List String)
port outgoingCommands =
  inbox.signal
  |> Signal.map (\action -> action |> toString |> String.split(" "))
  |> Signal.filter isOutgoing []

isOutgoing event =
  List.member (eventName event) [ "StartReview", "AbandonReview", "MarkAsReviewed", "MarkAsNew" ]

eventName event =
  event
  |> List.head
  |> Maybe.withDefault ""


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
