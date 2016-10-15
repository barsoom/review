module CommentList.Filter exposing (filter, isYourCommit, isYourComment, isCommentOnYourComment)

import Shared.Types exposing (..)
import Shared.Formatting exposing (authorName)
import Settings.Types exposing (Settings)
import String


filter : Settings -> List Comment -> List Comment
filter settings comments =
    comments
        |> filterCommentsNotOnYourCommitsOrComments (settings)
        |> filterCommentsYouWrote (settings)
        |> filterCommentsByResolved (settings)


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
        comments
            |> List.filter
                (\comment ->
                    (isCommentOnYourComment comments comment settings) || (isYourCommit comment settings)
                )


isCommentOnYourComment : List Comment -> Comment -> Settings -> Bool
isCommentOnYourComment comments comment settings =
    let
        commentsOnSameThread =
            comments
                |> List.filter (\c -> c.threadIdentifier == comment.threadIdentifier)

        yourCommentsOnSameThread =
            commentsOnSameThread
                |> List.filter (\c -> isYourComment c settings)
    in
        yourCommentsOnSameThread /= []


isYourComment : Comment -> Settings -> Bool
isYourComment comment settings =
    String.contains settings.name (authorName comment.authorName)


isYourCommit : Comment -> Settings -> Bool
isYourCommit comment settings =
    (Maybe.withDefault "Unknown" comment.commitAuthorName)
        |> String.contains (settings.name)
