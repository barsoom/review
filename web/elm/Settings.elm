module Settings where

import Settings.Types exposing (..)
import Settings.View exposing (view)
import Settings.Update exposing (update)


---- API to the outside world (javascript/server) ----

-- none so far

---- current state and action collection ----

main =
  Signal.map (view inbox.address) model

model : Signal Model
model =
  Signal.foldp update initialModel actions

initialModel : Model
initialModel =
  {
    settings = {
      email = ""
    , name = ""
    }
  , exampleAuthor = "Charles Babbage"
  }

actions : Signal Action
actions =
  inbox.signal

inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp
