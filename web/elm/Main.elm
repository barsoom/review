module Main exposing (main)

import Types exposing (..)
import Ports exposing (..)
import Update exposing (update)
import Html.App as Html
import VirtualDom exposing (Node)

import Html exposing (div)
import Html.Attributes exposing (class)

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
      [ commits UpdateCommits
      , settings UpdateSettings
      , updatedCommit UpdateCommit
      , environment UpdateEnvironment
      ] |> Sub.batch
    }

initialModel : Model
initialModel =
  {
    activeTab = CommitsTab
  , environment = "unknown"
  , settings = { email = "", name = "" }
  , exampleAuthor = "Charles Babbage"
  , commits = []
  , lastClickedCommitId = 0
  }

view : Model -> Node Msg
view model =
  div [ class "wrapper" ] [
    Menu.view model
  , renderTabContents model
  ]

renderTabContents : Model -> Node Msg
renderTabContents model =
  case model.activeTab of
    CommitsTab  -> CommitList.view model
    CommentsTab -> CommentList.view model
    SettingsTab -> Settings.view model
