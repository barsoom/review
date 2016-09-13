module Main exposing (main)

import Html.App as Html
import Html exposing (div, text)
import Html.Attributes exposing (class)
import VirtualDom exposing (Node)
import Time exposing (inMilliseconds)

import SharedTypes exposing (..)
import Constants exposing (defaultCommitsToShowCount)
import Update exposing (update)
import Ports

import Connectivity
import Menu
import CommitList
import CommentList
import Settings

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
      , (Time.every (inMilliseconds 500) ListMoreCommits)
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
    Connectivity.view model
  , Menu.view model
  , renderTabContents model
  ]

renderTabContents : Model -> Node Msg
renderTabContents model =
  case model.activeTab of
    CommitsTab  -> CommitList.view model
    CommentsTab -> CommentList.view model
    SettingsTab -> Html.map ChangeSettings (Settings.view model.settings)
