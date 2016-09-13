module Main exposing (main)

import Menu
import CommitList
import CommentList
import Settings

import SharedTypes exposing (..)
import Constants exposing (defaultCommitsToShowCount)
import Update exposing (update)
import Ports

import Html exposing (div, text)
import Html.App as Html
import Html.Attributes exposing (class)
import VirtualDom exposing (Node)
import Time exposing (inMilliseconds)

main : Program Never
main =
  Html.program
    { init = (initialModel, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \_ ->
      [ Ports.commits UpdateCommits
      , Ports.comments UpdateComments
      , Ports.settings UpdateSettings
      , Ports.updatedCommit UpdateCommit
      , Ports.environment UpdateEnvironment
      , Ports.location LocationChange
      , Ports.connectionStatus UpdateConnectionStatus
      , (Time.every (inMilliseconds 1000) ListMoreCommits)
      ] |> Sub.batch
    }

initialModel : Model
initialModel =
  {
    activeTab = CommitsTab
  , environment = "unknown"
  , settings = Settings.initialModel
  , commits = []
  , commitCount = 0
  , comments = []
  , commentsToShow = []
  , lastClickedCommitId = 0
  , lastClickedCommentId = 0
  , commitsToShowCount = defaultCommitsToShowCount
  , connected = Unknown
  }

view : Model -> Node Msg
view model =
  div [ class "wrapper" ] [
    renderConnectivity model
  , Menu.view model
  , renderTabContents model
  ]

renderConnectivity : Model -> Node a
renderConnectivity model =
  case model.connected of
    Unknown ->
      div [ class "connected connected--unknown" ] [ text "Initializing..." ]
    Yes ->
      div [ class "connected connected--yes" ] [ text "Connected" ]
    No ->
      div [ class "connected connected--no" ] [ text "Attempting to reconnect..." ]

renderTabContents : Model -> Node Msg
renderTabContents model =
  case model.activeTab of
    CommitsTab  -> CommitList.view model
    CommentsTab -> CommentList.view model
    SettingsTab -> Html.map ChangeSettings (Settings.view model.settings)
