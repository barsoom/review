module Settings.Types (Action (..), Model, Field, Settings) where

import Html exposing (Attribute)

type Action
  = NoOp
  | UpdateEmail String
  | UpdateName String
  | UpdateSettings Settings
  | Initialized Bool

type alias Model = {
    settings: Settings
  , exampleAuthor : String
  , initialized : Bool
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
  , onInput : Attribute
  }

