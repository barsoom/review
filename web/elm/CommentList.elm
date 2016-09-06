module CommentList exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import VirtualDom exposing (Node)
import Types exposing (..)

view : Model -> Html a
view model =
  ul [ class "comments-list" ] (List.map (renderComment model) model.comments)

renderComment : Model -> Comment -> Node a
renderComment model comment =
  li [ id (commentId comment), class "test-comment" ] [
    a [ class "block-link" ] [
      div [ class "comment-proper" ] [
        div [ class "comment-proper-author" ] [
          text "comment"
        ]
      , div [ class "comment-proper-body" ] [
          text "todo: implement comment listing"
        ]
      ]
    ]
  ]

commentId : Comment -> String
commentId comment =
  "comment-" ++ toString comment.id
