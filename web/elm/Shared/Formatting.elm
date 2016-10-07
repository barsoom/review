module Shared.Formatting exposing (formattedTime, authorName)

import Date
import Date.Format

formattedTime : String -> String
formattedTime timestamp =
  timestamp
  |> Date.fromString
  |> Result.withDefault (Date.fromTime 0)
  |> Date.Format.format "%a %e %b at %H:%M" -- E.g. Wed 3 Feb at 15:14

authorName : Maybe String -> String
authorName name =
  Maybe.withDefault "Unknown author" name
