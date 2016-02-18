module Settings.Types (Action (..), Model, Field) where

type Action
  = NoOp

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

