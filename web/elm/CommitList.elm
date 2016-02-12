module CommitList where

import CommitList.Types exposing (..)
import CommitList.View exposing (view)
import CommitList.Update exposing (update)

import Html exposing (..)
import String


---- API to the outside world (javascript/server) ----

--- receives commits to display at the start
port initialCommits : List Commit

-- receives updated commit data
port updatedCommit : Signal Commit

-- publishes events like [ "StartReview", "12" ]
port outgoingCommands : Signal (List String)
port outgoingCommands =
  inbox.signal
  |> Signal.map (\action -> action |> toString |> String.split(" "))
  |> Signal.filter isOutgoing []

isOutgoing event =
  List.member (eventName event) [ "StartReview", "AbandonReview" ]

eventName event =
  event
  |> List.head
  |> Maybe.withDefault ""


---- current state and action collection ----

model : Signal Model
model =
  Signal.foldp update initialModel actions

initialModel : Model
initialModel =
  { commits = initialCommits
  , lastClickedCommitId = 0
  }

actions : Signal Action
actions =
  Signal.merge inbox.signal updatedCommitSignal

updatedCommitSignal =
  updatedCommit
  |> Signal.map UpdatedCommit

inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp

main : Signal Html
main =
  Signal.map (view inbox.address) model
