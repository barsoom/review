module CommentList exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import VirtualDom exposing (Node, Property)
import Maybe

import Types exposing (..)
import Formatting exposing (formattedTime)
import Avatar exposing (avatarUrl)
import CommentFilter exposing (filter, isYourCommit, isYourComment, isCommentOnYourComment)
import CommentSettings exposing (view)

view : Model -> Html Msg
view model =
  div [] [
    renderCommentSettings(model.settings)
  , renderCommentList(model)
  ]

renderCommentSettings : Settings -> Node Msg
renderCommentSettings settings =
  CommentSettings.view settings

renderCommentList : Model -> Node Msg
renderCommentList model =
  let
    commentsToShow = filterComments model
  in
    if (List.length commentsToShow) == 0 then
      text "There are no comments yet! Write some."
    else
      ul [ class "comments-list" ] (List.map (renderComment model) commentsToShow)

filterComments : Model -> List Comment
filterComments model =
  model.comments
  |> CommentFilter.filter(model.settings)

renderComment : Model -> Comment -> Node Msg
renderComment model comment =
  li [ id (commentId comment), (commentClassList model comment) ] [
    a [ class "block-link", onClick (StoreLastClickedCommentId comment.id), href (commentUrl model comment) ] [
      div [ class "comment-proper" ] [
        div [ class "comment-proper-author" ] [
          div [ class "comment-controls" ] [
            button [ class "small mark-as-resolved" ] [
              i [ class "fa fa-eye" ] [ text "Mark as resolved" ]
            ]
          ]
        , img [ class "comment-proper-author-gravatar", src (avatarUrl (Just comment.authorGravatar)) ] []
        , i [ class "fa fa-chevron-right commenter-to-committer-arrow" ] []
        , img [ class "comment-commit-author-gravatar", src (avatarUrl comment.commitAuthorGravatar) ] []
        , strong [] [ text (commitAuthorName comment) ]
        , text " on "
        , span [ class "known-commit" ] [
            em [ class "comment-commit-summary" ] [ text (Maybe.withDefault "" comment.commitSummary) ]
          ]
        , text " on "
        , span [] [ text (formattedTime comment.timestamp) ]
        ]
      , div [ class "comment-proper-body" ] [
          text comment.body
        ]
      ]
    ]
  ]

commitAuthorName : Comment -> String
commitAuthorName comment =
  Maybe.withDefault "Unknown" comment.commitAuthorName

commentClassList : Model -> Comment -> Property a
commentClassList model comment =
  classList [
    ("comment", True)
  , ("test-comment", True)
  , ("your-last-clicked", (model.lastClickedCommentId == comment.id))
  , ("authored-by-you", (isYourComment comment model.settings))
  , ("on-your-commit", (isYourCommit comment model.settings))
  , ("on-your-comment", (isCommentOnYourComment model.comments comment model.settings))
  , ("is-resolved", comment.resolved)
  ]

commentUrl : Model -> Comment -> String
commentUrl model comment =
  if model.environment == "test" || model.environment == "dev" then
     "#"
  else
    comment.url

commentId : Comment -> String
commentId comment =
  "comment-" ++ toString comment.id
