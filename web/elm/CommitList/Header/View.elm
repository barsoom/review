module CommitList.Header.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import VirtualDom exposing (Node)
import String

import Shared.Types exposing (..)
import Shared.Formatting exposing (authorName)

view : Model -> Node a
view model =
  p [ class "left-to-review" ] [
    strong [] [ number <| reviewableCount model ]
  , text " commits to review: "
  , strong [] [ number <| reviewableByOthersCount model ]
  , text " by others, "
  , strong [] [ number <| reviewableByYouCount model ]
  , text " by you "
  , br [] []
  , text "Oldest by others: "
  , a [ href "" ] [ text "wip" ]
  ]

  --, a fluid-app-link="" href="https://github.com/barsoom/auctionet/commit/8bca6a3b1a5d8cc0065bb17d9cb94a1899c32505" ng-click="jumpTo(stats.oldestCommitYouCanReview)" class="ng-binding">Fri 7 Oct at 11:21 </a></span><!-- end ngIf: stats.oldestCommitYouCanReview --></p>
-- p [ class "nothing-left-to-review" ] [ s="fa fa-trophy fa-2x trophy"></i> <span class="text"><strong>Nothing left to review!</strong> Good job. </span></p>

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
  model.commits
  |> List.filter (\commit ->
    not (
      commit.isReviewed ||
      (String.contains model.settings.name (authorName commit.authorName))
    )
  )
  |> List.length
