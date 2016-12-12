module CommitList.Header.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import VirtualDom exposing (Node)
import String
import Shared.Types exposing (..)
import Shared.Formatting exposing (authorName, formattedTime)
import Shared.CompletedBadge
import CommitList.Header.InReviewByYou


view : Model -> Node Msg
view model =
    let
        totalCount =
            reviewableCount model
    in
        if totalCount == 0 then
            Shared.CompletedBadge.view "review"
        else
            calculatedReviewableCount = reviewableCount model
            p [ class "left-to-review" ]
                [ strong [] [ number <| calculatedReviewableCount ]
                , text " " ++ (pluralize calculatedReviewableCount "commit" "commits") ++ " to review: "
                , strong [] [ number <| reviewableByOthersCount model ]
                , text " by others, "
                , strong [] [ number <| reviewableByYouCount model ]
                , text " by you "
                , renderOldestReviewableCommitLink model
                ]


renderOldestReviewableCommitLink : Model -> Node Msg
renderOldestReviewableCommitLink model =
    if hasOldestReviewableCommit model then
        div []
            [ text "Oldest by others: "
            , a
                [ href <| oldestReviewableCommitUrl model
                , onClick (FocusCommitById <| oldestReviewableCommitId model)
                ]
                [ text <| oldestReviewableCommitTimestamp model
                ]
            , CommitList.Header.InReviewByYou.view model
            ]
    else
        div [] []

pluralize : Int -> String -> String -> String
pluralize count singularString pluralString =
    if count == 1 then singularString else pluralString

number : Int -> Node a
number n =
    n |> toString |> text


reviewableByYouCount : Model -> Int
reviewableByYouCount model =
    (reviewableCount model) - (reviewableByOthersCount model)


reviewableByOthersCount : Model -> Int
reviewableByOthersCount model =
    model
        |> reviewableCommits
        |> List.length


reviewableCount : Model -> Int
reviewableCount model =
    model.commits
        |> List.filter (\commit -> not commit.isReviewed)
        |> List.length


oldestReviewableCommitId : Model -> Int
oldestReviewableCommitId model =
    case oldestReviewableCommit model of
        Just commit ->
            commit.id

        Nothing ->
            -1


oldestReviewableCommitTimestamp : Model -> String
oldestReviewableCommitTimestamp model =
    case oldestReviewableCommit model of
        Just commit ->
            formattedTime commit.timestamp

        Nothing ->
            "If this is shown, someone forgot to ask if hasOldestReviewableCommit is true before calling this function."


oldestReviewableCommitUrl : Model -> String
oldestReviewableCommitUrl model =
    case oldestReviewableCommit model of
        Just commit ->
            commit.url

        Nothing ->
            "If this is shown, someone forgot to ask if hasOldestReviewableCommit is true before calling this function."


hasOldestReviewableCommit : Model -> Bool
hasOldestReviewableCommit model =
    case oldestReviewableCommit model of
        Just commit ->
            True

        Nothing ->
            False


oldestReviewableCommit : Model -> Maybe Commit
oldestReviewableCommit model =
    model
        |> reviewableCommits
        |> List.sortBy .timestamp
        |> List.head


reviewableCommits : Model -> List Commit
reviewableCommits model =
    model.commits
        |> List.filter
            (\commit ->
                not
                    (commit.isReviewed
                        || (String.contains model.settings.name (authorName commit.authorName))
                    )
            )
