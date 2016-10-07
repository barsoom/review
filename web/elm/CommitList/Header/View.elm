module CommitList.Header.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import VirtualDom exposing (Node)

import Shared.Types exposing (..)

view : Model -> Node a
view model =
  p [ class "left-to-review" ] [
    strong [] [ text "wip" ]
  , text " commits to review: "
  , strong [] [ text "wip" ]
  , text " by others, "
  , strong [] [ text "wip" ]
  , text " by you "
  , br [] []
  , text "Oldest by others: "
  , a [ href "" ] [ text "wip" ]
  ]

  --, a fluid-app-link="" href="https://github.com/barsoom/auctionet/commit/8bca6a3b1a5d8cc0065bb17d9cb94a1899c32505" ng-click="jumpTo(stats.oldestCommitYouCanReview)" class="ng-binding">Fri 7 Oct at 11:21 </a></span><!-- end ngIf: stats.oldestCommitYouCanReview --></p>
-- p [ class "nothing-left-to-review" ] [ s="fa fa-trophy fa-2x trophy"></i> <span class="text"><strong>Nothing left to review!</strong> Good job. </span></p>
