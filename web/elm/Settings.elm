module Settings exposing (view, update, initialModel)

import SettingsTypes exposing (..)

import Html exposing (div, span, form, p, label, text, input, Html)
import Html.Attributes exposing (class, for, id, value, property, name)
import Html.Events exposing (on, targetValue, onInput)
import String.Interpolate exposing (interpolate)
import Json.Encode
import VirtualDom exposing (Node, Property)
import String

initialModel : Settings
initialModel =
  { email = ""
  , name = ""
  , showCommentsYouWrote = True
  , showCommentsOnOthers = True
  , showResolvedComments = True
  }

update : Settings -> SettingsMsg -> Settings
update settings msg =
  case msg of
    UpdateName value                 -> {settings | name = value}
    UpdateEmail value                -> {settings | email = value}
    UpdateShowCommentsYouWrote value -> {settings | showCommentsYouWrote = value}
    UpdateShowResolvedComments value -> {settings | showResolvedComments = value}
    UpdateShowCommentsOnOthers value -> {settings | showCommentsOnOthers = value}

view : Settings -> Html SettingsMsg
view settings =
  div [ class "settings-wrapper" ] [
    form [] [
      -- type="email" causes "bouncing" of .please-provide-details
      -- because "foo@bar." is not considered a real value.
      textField {
        id = "settings-email"
      , name = "email"
      , label = "Your email:"
      , value = settings.email
      , onInput = UpdateEmail
    }
    , emailHelpText

    , textField {
      id = "settings-name"
    , name = "name"
    , label = "Your name:"
    , value = settings.name
    , onInput = UpdateName
    }
  ]

  , helpText [
      p [ innerHtml "Determines <em>your</em> commits and comments by substring." ] []
    , p [] [
        span [ class "test-usage-explanation" ] [ text (usageExample settings) ]
      ]
    ]
  ]

emailHelpText : Node a
emailHelpText =
  helpText [
    text "Uniquely identifies you as a reviewer. Used for"
  --, img [ class "settings-gravatar" ] # TODO: display gavatar and only when an email exists
  , text " your Gravatar."
  ]

textField : Field -> Html SettingsMsg
textField field =
  p [] [
    label [ for field.id ] [ text field.label ]
  , text " "

  , input [ id field.id, name field.name, value field.value, onInput field.onInput ] []
  ]

usageExample : Settings -> String
usageExample settings =
  if String.isEmpty(settings.name) then
    interpolate """If your name is "{0}", a commit authored e.g. by "{0}" or by "Ada Lovelace and {0}" will be considered yours."""  [ exampleAuthor ]
  else
    interpolate """A commit authored e.g. by "{0}" or by "Ada Lovelace and {0}" will be considered yours."""  [ settings.name ]

innerHtml : String -> Property a
innerHtml htmlString =
  property "innerHTML" (Json.Encode.string htmlString)

helpText : List (Html a) -> Html a
helpText =
  p [ class "help-text" ]

exampleAuthor : String
exampleAuthor = "Charles Babbage"
