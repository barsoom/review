module Shared.Avatar exposing (avatarUrl)

avatarUrl : Maybe String -> String
avatarUrl gravatarHash =
  let
    hash = (Maybe.withDefault "" gravatarHash)
  in
    "https://secure.gravatar.com/avatar/" ++ hash ++ "?size=40&amp;rating=x&amp;default=mm"
