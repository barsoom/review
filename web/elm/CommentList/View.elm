module CommentList.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import VirtualDom exposing (Node, Property)
import Maybe

import Shared.Types exposing (..)
import Shared.Formatting exposing (formattedTime, authorName)
import Shared.Change exposing (changeMsg)
import Shared.Avatar exposing (avatarUrl)
import Settings.Types exposing (..)
import CommentList.Filter exposing (filter, isYourCommit, isYourComment, isCommentOnYourComment)
import CommentList.Settings.View

view : Model -> Html Msg
view model =
  div [] [
    renderCommentSettings(model.settings)
  , renderCommentList(model)
  ]

renderCommentSettings : Settings -> Node Msg
renderCommentSettings settings =
  CommentList.Settings.View.view settings

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
  |> CommentList.Filter.filter(model.settings)

renderComment : Model -> Comment -> Node Msg
renderComment model comment =
  li [ id (commentId comment), (commentClassList model comment), resolverDataAttribute(comment.resolverEmail) ] [
    a [ class "block-link", onClick (StoreLastClickedCommentId comment.id), href (commentUrl model comment) ] [
      div [ class "comment-proper" ] [
        div [ class "comment-proper-author" ] [
          div [ class "comment-controls" ] [
            renderButton model comment
          ]
        , img [ class "comment-proper-author-gravatar", src (avatarUrl comment.authorGravatar) ] []
        , i [ class "fa fa-chevron-right commenter-to-committer-arrow" ] []
        , img [ class "comment-commit-author-gravatar", src (avatarUrl comment.commitAuthorGravatar) ] []
        , strong [] [ text (authorName comment.authorName) ]
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

renderButton : Model -> Comment -> Html Msg
renderButton model comment  =
  if comment.resolved then
    div [] [
      img [ class "comment-resolver-avatar", src (avatarUrl comment.resolverGravatar) ] []
    , button [ class "small mark-as-new test-button", onClick (changeMsg MarkCommentAsNew model comment) ] [
        i [ class "fa fa-eye-slash" ] []
      , text " Mark as new"
      ]
    ]
  else
    button [ class "small mark-as-resolved test-button", onClick (changeMsg MarkCommentAsResolved model comment) ] [
      i [ class "fa fa-eye" ] []
    , text " Mark as resolved"
    ]

resolverDataAttribute : Maybe String -> Attribute a
resolverDataAttribute email =
  attribute "data-test-resolver-email" (Maybe.withDefault "" email)

commentClassList : Model -> Comment -> Property a
commentClassList model comment =
  let
    onYourCommit = isYourCommit comment model.settings
    onYourComment = isCommentOnYourComment model.comments comment model.settings
    authoredByYou = isYourComment comment model.settings
  in
    classList [
      ("comment", True)
    , ("your-last-clicked", (model.lastClickedCommentId == comment.id))
    , ("authored-by-you", authoredByYou)
    , ("on-your-commit", onYourCommit)
    , ("on-your-comment", onYourComment)
    , ("is-resolved", comment.resolved)
    , ("test-comment", True)
    , ("test-authored-by-you", authoredByYou)
    , ("test-resolved", comment.resolved)
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
