module Settings.Update (update) where

import Settings.Types exposing (..)

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    UpdateEmail email ->
      let settings = model.settings
      in {model | settings = {settings | email = email}}

    UpdateName name ->
      let settings = model.settings
      in {model | settings = {settings | name = name}}

    UpdateSettings settings ->
      {model | settings = settings}

    Initialized value ->
      {model | initialized = value}
