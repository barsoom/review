module Main exposing (main)

import Html.App as Html
import Html exposing (div, text)
import Html.Attributes exposing (class)
import VirtualDom exposing (Node)

import Shared.Types exposing (..)
import Shared.State
import Connectivity
import Menu
import CommitList
import CommentList
import Settings.View

main : Program Never
main =
  Html.program
    { init = (Shared.State.initialModel, Cmd.none)
    , view = view
    , update = Shared.State.update
    , subscriptions = Shared.State.subscriptions
    }

view : Model -> Node Msg
view model =
  div [ class "wrapper" ] [
    Connectivity.view model
  , Menu.view model
  , renderTabContents model
  ]

renderTabContents : Model -> Node Msg
renderTabContents model =
  case model.activeTab of
    CommitsTab  -> CommitList.view model
    CommentsTab -> CommentList.view model
    SettingsTab -> Html.map ChangeSettings (Settings.View.view model.settings)
