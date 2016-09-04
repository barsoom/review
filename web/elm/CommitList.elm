module CommitList exposing (main)

import CommitList.Types exposing (..)
import CommitList.View exposing (view)
import CommitList.Update exposing (update)
import Ports exposing (..)

import Html.App as Html

main : Program Never
main =
  Html.program
    { init = (initialModel, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \_ ->
      [ commits UpdateCommits
      , settings UpdateSettings
      , updatedCommit UpdateCommit
      ] |> Sub.batch
    }

initialModel : Model
initialModel =
  {
    commits = []
  , settings = { email = "", name = "" }
  , lastClickedCommitId = 0
  , environment = "unknown"
  }
