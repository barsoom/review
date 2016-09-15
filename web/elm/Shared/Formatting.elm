module Shared.Formatting exposing (formattedTime)

import Date
import Date.Format

formattedTime : String -> String
formattedTime timestamp =
  timestamp
  |> Date.fromString
  |> Result.withDefault (Date.fromTime 0)
  |> Date.Format.format "%a %e %b at %H:%M" -- E.g. Wed 3 Feb at 15:14
