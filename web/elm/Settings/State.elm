module Settings.State exposing (subscriptions, initialModel, update)

import Shared.Ports
import Settings.Types exposing (..)
import Shared.Types exposing (Msg (UpdateSettings))

subscriptions : Sub Msg
subscriptions =
  Shared.Ports.settings UpdateSettings

initialModel : Settings
initialModel =
  { email = ""
  , name = ""
  , showCommentsYouWrote = True
  , showCommentsOnOthers = True
  , showResolvedComments = True
  }

update : Settings -> SettingsMsg -> Settings
update settings msg =
  case msg of
    UpdateName value                 -> {settings | name = value}
    UpdateEmail value                -> {settings | email = value}
    UpdateShowCommentsYouWrote value -> {settings | showCommentsYouWrote = value}
    UpdateShowResolvedComments value -> {settings | showResolvedComments = value}
    UpdateShowCommentsOnOthers value -> {settings | showCommentsOnOthers = value}
