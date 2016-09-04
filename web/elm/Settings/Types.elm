module Settings.Types exposing (Msg (..), Model, Field, Settings)

import Html exposing (Attribute)

type Msg
  = NoOp
  | UpdateEmail String
  | UpdateName String
  | UpdateSettings Settings

type alias Model = {
    settings: Settings
  , exampleAuthor : String
  }

type alias Settings = {
    name : String
  , email : String
  }

type alias Field = {
    id : String
  , label : String
  , name : String
  , value : String
  , onInput : Msg
  }

