module Connectivity.State exposing (subscriptions)

import Shared.Types exposing (Msg(UpdateConnectionStatus))
import Shared.Ports


subscriptions : Sub Msg
subscriptions =
    Shared.Ports.connectionStatus UpdateConnectionStatus
