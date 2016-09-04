module Menu exposing (view)

import Types exposing (..)
import Html exposing (text, div, span, i, li, ul, nav, a)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import VirtualDom exposing (Node)
import String

view : Model -> Node Msg
view model =
  nav [ class "top-nav" ] [
    ul [] [
      renderMenuItem "Commits" CommitsTab
    , renderMenuItem "Comments" CommentsTab
    , renderMenuItem "Settings" SettingsTab
    ]
  ]

renderMenuItem : String -> Tab -> Node Msg
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
