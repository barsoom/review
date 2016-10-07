module CommitList.Header.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import VirtualDom exposing (Node)
import String

import Shared.Types exposing (..)
import Shared.Formatting exposing (authorName, formattedTime)

view : Model -> Node a
view model =
  let
    totalCount = reviewableCount model
  in
    if totalCount == 0 then
      p [ class "nothing-left-to-review" ] [
        i [ class "fa fa-trophy fa-2x trophy" ] []
      , span [ class "text" ] [
          strong [] [ text "Nothing left to review!" ]
        , text " Good job."
        ]
      ]
    else
      p [ class "left-to-review" ] [
        strong [] [ number <| reviewableCount model ]
      , text " commits to review: "
      , strong [] [ number <| reviewableByOthersCount model ]
      , text " by others, "
      , strong [] [ number <| reviewableByYouCount model ]
      , text " by you "
      , renderOldestReviewableCommitLink model
      ]

-- TODO: make clicking on it focus the commit in the list
renderOldestReviewableCommitLink : Model -> Node a
renderOldestReviewableCommitLink model =
  if hasOldestReviewableCommit model then
    div [] [
        text "Oldest by others: "
      , a [ href <| oldestReviewableCommitUrl model ] [ text <| oldestReviewableCommitTimestamp model ]
    ]
  else
    div [] []

  --, a fluid-app-link="" href="https://github.com/barsoom/auctionet/commit/8bca6a3b1a5d8cc0065bb17d9cb94a1899c32505" ng-click="jumpTo(stats.oldestCommitYouCanReview)" class="ng-binding">Fri 7 Oct at 11:21 </a></span><!-- end ngIf: stats.oldestCommitYouCanReview --></p>

number : Int -> Node a
number n =
  n |> toString |> text

reviewableByOthersCount : Model -> Int
reviewableByOthersCount model =
  (reviewableCount model) - (reviewableByYouCount model)

reviewableCount : Model -> Int
reviewableCount model =
  model.commits
  |> List.filter (\commit -> not commit.isReviewed)
  |> List.length

reviewableByYouCount : Model -> Int
reviewableByYouCount model =
  model
  |> reviewableCommits
  |> List.length

oldestReviewableCommitTimestamp : Model -> String
oldestReviewableCommitTimestamp model =
  case oldestReviewableCommit model of
    Just commit ->
      formattedTime commit.timestamp
    Nothing ->
      "If this is shown, someone forgot to check hasOldestReviewableCommit"

oldestReviewableCommitUrl : Model -> String
oldestReviewableCommitUrl model =
  case oldestReviewableCommit model of
    Just commit ->
      commit.url
    Nothing ->
      "If this is shown, someone forgot to check hasOldestReviewableCommit"

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
  |> List.filter (\commit ->
    not (
      commit.isReviewed ||
      (String.contains model.settings.name (authorName commit.authorName))
    )
  )
