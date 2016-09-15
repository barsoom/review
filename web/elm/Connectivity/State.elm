module Connectivity.State exposing (subscriptions)

import Shared.Types exposing (Msg (UpdateConnectionStatus))
import Ports

subscriptions : Sub Msg
subscriptions =
  Ports.connectionStatus UpdateConnectionStatus
