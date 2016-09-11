module Change exposing (changeMsg)

import Types exposing (..)

changeMsg : (Change -> a) -> Model -> Identifyable b -> a
changeMsg msg model record =
  msg { byEmail = model.settings.email, id = record.id }

