port module Settings exposing (main)

import Html.App as Html

import Settings.Types exposing (..)
import Settings.View exposing (view)

---- API to the outside world (javascript/server) ----

port settings : (Settings -> msg) -> Sub msg
port settingsChange : Settings -> Cmd msg

---- current state and action collection ----

main =
  Html.program
    { init = (initialModel, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \_ ->
      settings UpdateSettings
    }

update : Msg -> Model -> (Model, Cmd a)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)

    UpdateEmail email ->
      let
        s = model.settings
        settings = { s | email = email }
      in
        ({model | settings = settings}, settingsChange settings)

    UpdateName name ->
      let
        s = model.settings
        settings = { s | name = name }
      in
        ({model | settings = settings}, settingsChange settings)

    UpdateSettings settings ->
      ({model | settings = settings}, Cmd.none)


initialModel : Model
initialModel =
  {
    settings = {
      email = ""
    , name = ""
    }
  , exampleAuthor = "Charles Babbage"
  }
