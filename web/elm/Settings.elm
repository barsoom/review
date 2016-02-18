module Settings where

import Settings.Types exposing (..)
import Settings.View exposing (view)
import Settings.Update exposing (update)


---- API to the outside world (javascript/server) ----

port settings : Signal Settings

port settingsChange : Signal Settings
port settingsChange =
  model |> Signal.map .settings

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
  Signal.merge inbox.signal (Signal.map UpdateSettings settings)

inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp
