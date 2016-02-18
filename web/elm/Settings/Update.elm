module Settings.Update (update) where

import Settings.Types exposing (..)

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    UpdateEmail email ->
      {model | email = email}

    UpdateName name ->
      {model | name = name}
