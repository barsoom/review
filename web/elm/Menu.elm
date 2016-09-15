module Menu exposing (view)

import Shared.Types exposing (..)
import Html exposing (text, div, span, i, li, ul, nav, a)
import Html.Attributes exposing (class, href, classList)
import Html.Events exposing (onClick)
import VirtualDom exposing (Node, Property)
import String

view : Model -> Node Msg
view model =
  nav [ class "top-nav" ] [
    ul [] [
      renderMenuItem model "Commits" "fa-eye" CommitsTab
    , renderMenuItem model "Comments" "fa-comments" CommentsTab
    , renderMenuItem model "Settings" "fa-cog" SettingsTab
    ]
  ]

renderMenuItem : Model -> String -> String -> Tab -> Node Msg
renderMenuItem model name customClass tab =
  li [ (menuClassList model tab) ] [
    a [ onClick (SwitchTab tab) ] [
      span [] [
        i [ class ("fa fa-lg " ++ customClass) ] []
        , span [] [ text name ]
        , (renderBadge model tab)
      ]
    ]
  ]

menuClassList : Model -> Tab -> Property a
menuClassList model tab =
  classList [
    ("current", model.activeTab == tab)
  ]

renderBadge : Model -> Tab -> Node a
renderBadge model tab =
  if tab == CommitsTab then
    span [ class "commits-badge" ] [
      text (toString (reviewableCommitsCount model))
    ]
  else
    span [] []

reviewableCommitsCount : Model -> Int
reviewableCommitsCount model =
  model.commits
  |> List.filter(\c -> not c.isReviewed)
  |> List.filter(\c -> not (String.contains model.settings.name c.authorName))
  |> List.length
