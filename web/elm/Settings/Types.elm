module Settings.Types (Action (..), Model, Field) where

import Html exposing (Attribute)

type Action
  = NoOp
  | UpdateEmail String
  | UpdateName String

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
  , onInput : Attribute
  }

