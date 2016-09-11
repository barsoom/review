module CommentList exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import VirtualDom exposing (Node, Property)
import Maybe
import Types exposing (..)
import Formatting exposing (formattedTime)
import Avatar exposing (avatarUrl)
import String

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
  let
    commentsToShow = (filterComments model.settings model.comments)
  in
    if (List.length commentsToShow) == 0 then
      text "There are no comments yet! Write some."
    else
      ul [ class "comments-list" ] (List.map (renderComment model) commentsToShow)

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

filterComments : Settings -> List Comment -> List Comment
filterComments settings comments =
  comments
  |> filterCommentsNotOnYourCommitsOrComments(settings)
  |> filterCommentsYouWrote(settings)
  |> filterCommentsByResolved(settings)

filterCommentsYouWrote : Settings -> List Comment -> List Comment
filterCommentsYouWrote settings comments =
  if settings.showCommentsYouWrote then
    comments
  else
    comments |> List.filter (\comment -> not (isYourComment comment settings))

filterCommentsByResolved : Settings -> List Comment -> List Comment
filterCommentsByResolved settings comments =
  if settings.showResolvedComments then
    comments
  else
    comments |> List.filter (\comment -> not comment.resolved)

filterCommentsNotOnYourCommitsOrComments : Settings -> List Comment -> List Comment
filterCommentsNotOnYourCommitsOrComments settings comments =
  if settings.showCommentsOnOthers then
    comments
  else
    comments |> List.filter (\comment ->
      (isCommentOnYourComment comments comment settings) || (isYourCommit comment settings)
    )

isCommentOnYourComment : List Comment -> Comment -> Settings -> Bool
isCommentOnYourComment comments comment settings =
  let
    commentsOnSameThread = comments
      |> List.filter (\c -> c.threadIdentifier == comment.threadIdentifier)
    yourCommentsOnSameThread = commentsOnSameThread
      |> List.filter(\c -> isYourComment c settings)
  in
    yourCommentsOnSameThread /= []

isYourComment : Comment -> Settings -> Bool
isYourComment comment settings =
  String.contains settings.name comment.authorName

isYourCommit : Comment -> Settings -> Bool
isYourCommit comment settings =
  (Maybe.withDefault "Unknown" comment.commitAuthorName)
  |> String.contains(settings.name)

commentId : Comment -> String
commentId comment =
  "comment-" ++ toString comment.id
