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
      renderMenuItem "Commits" "fa-eye" CommitsTab
    , renderMenuItem "Comments" "fa-comments" CommentsTab
    , renderMenuItem "Settings" "fa-cog" SettingsTab
    ]
  ]

renderMenuItem : String -> String -> Tab -> Node Msg
renderMenuItem name customClass tab =
  let
    testClass = "test-menu-item-" ++ (String.toLower name)
  in
    li [] [
      a [ onClick (SwitchTab tab), class testClass ] [
        span [] [
          i [ class ("fa fa-lg " ++ customClass) ] []
          , span [] [ text name ]
        ]
      ]
    ]
