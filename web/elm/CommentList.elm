module CommentList exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import VirtualDom exposing (Node)
import Types exposing (..)

-- TODO:
-- filter things based on settings

view : Model -> Html a
view model =
  div [] [
    renderCommentSettings
  , renderCommentList(model)
  ]

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

renderCommentSettings : Node a
renderCommentSettings =
  div [ class "comment-settings" ] [
    renderOption "Comments I wrote"
  , renderOption "Comments on others"
  , renderOption "Resolved comments"
  ]

renderOption : String -> Node a
renderOption name =
  label [] [
    input [ type' "checkbox" ] []
  ,  text name
  ]

renderCommentList : Model -> Node a
renderCommentList model =
  ul [ class "comments-list" ] (List.map (renderComment model) model.comments)

commentId : Comment -> String
commentId comment =
  "comment-" ++ toString comment.id
