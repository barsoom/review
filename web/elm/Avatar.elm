module Avatar exposing (avatarUrl, maybeAvatarUrl)

avatarUrl : String -> String
avatarUrl hash =
  "https://secure.gravatar.com/avatar/" ++ hash ++ "?size=40&amp;rating=x&amp;default=mm"

maybeAvatarUrl : Maybe String -> String
maybeAvatarUrl gravatarHash =
  (Maybe.withDefault "" gravatarHash)
  |> avatarUrl
