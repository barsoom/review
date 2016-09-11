module CommentSettings exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import VirtualDom exposing (Node, Property)

view : Settings -> Node Msg
view settings =
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
