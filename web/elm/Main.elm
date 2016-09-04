module Main exposing (main)

import Types exposing (..)
import Ports exposing (..)
import Update exposing (update)
import Html.App as Html
import VirtualDom exposing (Node)

import Html exposing (text, div, span, i, li, ul, nav, a)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import String

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

view : Model -> Node Msg
view model =
  div [ class "wrapper" ] [
    nav [ class "top-nav" ] [
      ul [] [
        renderMenuItem "Commits" CommitsTab
      , renderMenuItem "Comments" CommentsTab
      , renderMenuItem "Settings" SettingsTab
      ]
    ]
  , renderTabContents model
  ]

renderMenuItem name tab =
  let
    testClass = "test-menu-item-" ++ (String.toLower name)
  in
    li [] [
      a [ href "#", onClick (SwitchTab tab), class testClass ] [
        span [] [
          i [ class "fa.fa-lg.fa-eye" ] []
          , span [] [ text name ]
        ]
      ]
    ]

renderTabContents : Model -> Node Msg
renderTabContents model =
  case model.activeTab of
    CommitsTab  -> CommitList.view model
    CommentsTab -> CommentList.view model
    SettingsTab -> Settings.view model

initialModel : Model
initialModel =
  {
    commits = []
  , settings = { email = "", name = "" }
  , exampleAuthor = "Charles Babbage"
  , lastClickedCommitId = 0
  , environment = "unknown"
  , activeTab = CommitsTab
  }
