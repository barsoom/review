module Settings where

import Html exposing (div, span, form, p, label, text, input, Html)
import Html.Attributes exposing (class, for, id, value, property, name)
import String.Interpolate exposing (interpolate)
import Json.Encode

main =
  render { email = "", name = "", exampleAuthor = "Charles Babbage" }

render model =
  div [ class "settings-wrapper" ] [
    form [] [
      -- type="email" causes "bouncing" of .please-provide-details
      -- because "foo@bar." is not considered a real value.
      textField { id = "settings-email", name = "email", label = "Your email:", value = model.email }
    , emailHelpText

    , textField { id = "settings-name", name = "name", label = "Your name:", value = model.name }
    ]

  , helpText [
      p [ innerHtml "Determines <em>your</em> commits and comments by substring." ] []
    , p [] [
        span [ class "test-usage-explanation" ] [ text (usageExample model) ]
      ]
    ]
  ]

emailHelpText =
  helpText [
    text "Uniquely identifies you as a reviewer. Used for"
  --, img [ class "settings-gravatar" ] # TODO: display gavatar and only when an email exists
  , text " your Gravatar."
  ]

textField : Field -> Html
textField field =
  p [] [
    label [ for field.id ] [ text field.label ]
  , text " "

  , input [ id field.id, name field.name, value field.value ] []
  ]

usageExample model =
  interpolate """If your name is "{0}", a commit authored e.g. by "{0}" or by "Ada Lovelace and {0}" will be considered yours."""  [ model.exampleAuthor ]

innerHtml htmlString =
  property "innerHTML" (Json.Encode.string htmlString)

helpText =
  p [ class "help-text" ]

type alias Model = {
    name : String
  , email : String
  , exampleAuthor : String
  }

type alias Field = {
    id : String
  , label : String
  , name : String
  , value : String
  }
