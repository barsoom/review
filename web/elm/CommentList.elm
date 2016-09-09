module CommentList exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import VirtualDom exposing (Node, Property)
import Maybe
import Types exposing (..)
import Formatting exposing (formattedTime)
import Avatar exposing (avatarUrl)

view : Model -> Html Msg
view model =
  div [] [
    renderCommentSettings(model.settings)
  , renderCommentList(model)
  ]

renderCommentSettings : Settings -> Node Msg
renderCommentSettings settings =
  div [ class "comment-settings" ] [
    renderOption {
      checked = settings.showCommentsYouWrote
    , class = "test-comments-i-wrote"
    , name = "Comments I wrote"
    , onCheck = UpdateShowCommentsYouWrote
    }
    , renderOption {
      checked = settings.showCommentsOnOthers
    , class = "test-comments-on-others"
    , name = "Comments on others"
    , onCheck = UpdateShowCommentsOnOthers
    }
    , renderOption {
      checked = settings.showResolvedComments
    , class = "test-resolved-comments"
    , name = "Resolved comments"
    , onCheck = UpdateShowResolvedComments
    }
  ]

renderOption : { checked : Bool, name : String, class : String, onCheck : Bool -> Msg } ->  Node Msg
renderOption option =
  label [] [
    input [ type' "checkbox", class option.class, checked option.checked, onCheck option.onCheck ] []
  ,  text option.name
  ]

renderCommentList : Model -> Node a
renderCommentList model =
  if (List.length model.comments) == 0 then
    text "There are no comments yet! Write some."
  else
    ul [ class "comments-list" ] (List.map (renderComment model) model.comments)

renderComment : Model -> Comment -> Node a
renderComment model comment =
  li [ id (commentId comment), (commentClassList comment) ] [
    a [ class "block-link" ] [
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

commentClassList : Comment -> Property a
commentClassList comment =
  -- TODO: logic and tests
  classList [
    ("your-last-clicked", False)
  , ("authored-by-you", False)
  , ("on-your-commit", True)
  , ("is-resolved", False)
  , ("test-comment", True)
  ]

commentId : Comment -> String
commentId comment =
  "comment-" ++ toString comment.id
