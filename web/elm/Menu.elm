module Menu exposing (view)

import SharedTypes exposing (..)
import Html exposing (text, div, span, i, li, ul, nav, a)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import VirtualDom exposing (Node)
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
  li [] [
    a [ onClick (SwitchTab tab) ] [
      span [] [
        i [ class ("fa fa-lg " ++ customClass) ] []
        , span [] [ text name ]
        , (renderBadge model tab)
      ]
    ]
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
