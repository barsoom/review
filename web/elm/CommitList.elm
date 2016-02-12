module CommitList where

import Html exposing (..)
import String

import CommitList.Types exposing (..)
import CommitList.View exposing (view)
import CommitList.Update exposing (update)

main : Signal Html
main =
  Signal.map (view inbox.address) model


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
  let name = event |> List.head |> Maybe.withDefault ""
  in  List.member name [ "StartReview", "AbandonReview" ]


---- current state and action collection ----

model =
  let initialModel = { commits = initialCommits, lastClickedCommitId = 0 }
  in Signal.foldp update initialModel actions

actions : Signal Action
actions =
  Signal.merge inbox.signal updatedCommitActions

updatedCommitActions : Signal Action
updatedCommitActions =
  Signal.map (\commit -> (UpdatedCommit commit)) updatedCommit

inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp
