module CommitList.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import String
import VirtualDom exposing (Node, Property)
import Shared.Formatting exposing (formattedTime, authorName)
import Shared.Types exposing (..)
import Settings.Types exposing (..)
import Shared.Change exposing (changeMsg)
import Shared.Avatar exposing (avatarUrl)
import Shared.Helpers exposing (onClickWithPreventDefault)
import CommitList.Header.View


view : Model -> Node Msg
view model =
    let
        commits =
            commitsToShow model

        toggleButtonText =
            (if model.settings.showAllReviewedCommits then
                "Hide most reviewed commits"
             else
                "Show more reviewed commits"
            )
    in
        div []
            [ CommitList.Header.View.view model
            , ul [ class "commits-list" ] (List.map (renderCommit model) commits)
            , ul [ class "commits-list" ]
                [ li [ class "centered-button-commit-row" ]
                    [ button [ onClick (ChangeSettings ToggleShowAllReviewedCommits) ] [ text toggleButtonText ]
                    ]
                ]
            ]


commitsToShow : Model -> List Commit
commitsToShow model =
    let
        list =
            model.commits |> List.take (model.commitsToShowCount)
    in
        if model.settings.showAllReviewedCommits then
            list
        else
            limitShownReviewedCommits list


limitShownReviewedCommits : List Commit -> List Commit
limitShownReviewedCommits list =
    let
        oldestUnreviewedCommit =
            list |> List.filter (\commit -> not commit.isReviewed) |> List.sortBy .timestamp |> List.head

        minReviewedCommitsToShowCount =
            5
    in
        case oldestUnreviewedCommit of
            Just commit ->
                Tuple.first (list |> List.partition (\c -> c.id + minReviewedCommitsToShowCount >= commit.id))

            Nothing ->
                list |> List.take (minReviewedCommitsToShowCount)


renderCommit : Model -> Commit -> Node Msg
renderCommit model commit =
    li [ id (commitId commit), (commitClassList model commit) ]
        [ a [ class "block-link", href (commitUrl model commit) ]
            [ div [ class "commit-wrapper", onClick (ShowCommit commit.id) ]
                [ div [ class "commit-controls" ] (renderButtons model commit)
                , img [ class "commit-avatar", src (avatarUrl commit.authorGravatarHash) ] []
                , div [ class "commit-summary-and-details" ]
                    [ div [ class "commit-summary test-summary" ] [ text commit.summary ]
                    , renderCommitDetails commit
                    ]
                ]
            ]
        ]


renderCommitDetails : Commit -> Node a
renderCommitDetails commit =
    div [ class "commit-details" ]
        [ text " in "
        , strong [] [ text commit.repository ]
        , span [ class "by-author" ]
            [ text " by "
            , strong [] [ text (authorName commit.authorName) ]
            , text " on "
            , span [ class "test-timestamp" ] [ text (formattedTime commit.timestamp) ]
            ]
        ]



-- don't link to github in tests since that makes testing difficult


commitUrl : Model -> Commit -> String
commitUrl model commit =
    if model.environment == "test" || model.environment == "dev" then
        "#"
    else
        commit.url


renderButtons : Model -> Commit -> List (Node Msg)
renderButtons model commit =
    if commit.isNew then
        [ commitButton
            { name = "Start review"
            , class = "start-review"
            , iconClass = "fa-eye"
            , msg = (changeMsg StartReview model commit)
            , openCommitOnGithub = (model.lastClickedCommitId /= commit.id)
            }
        ]
    else if commit.isBeingReviewed then
        [ commitButton
            { name = "Abandon review"
            , class = "abandon-review"
            , iconClass = "fa-eye-slash"
            , msg = (changeMsg AbandonReview model commit)
            , openCommitOnGithub = False
            }
        , commitButton
            { name = "Mark as reviewed"
            , class = "mark-as-reviewed"
            , iconClass = "fa-eye-slash"
            , msg = (changeMsg MarkAsReviewed model commit)
            , openCommitOnGithub = False
            }
        , img [ class "commit-reviewer-avatar test-reviewer", src (avatarUrl commit.pendingReviewerGravatarHash), reviewerDataAttribute (commit.pendingReviewerEmail) ] []
        ]
    else if commit.isReviewed then
        [ commitButton
            { name = "Mark as new"
            , class = "mark-as-new"
            , iconClass = "fa-eye-slash"
            , msg = (changeMsg MarkAsNew model commit)
            , openCommitOnGithub = False
            }
        , img [ class "commit-reviewer-avatar test-reviewer", src (avatarUrl commit.reviewerGravatarHash), reviewerDataAttribute (commit.reviewerEmail) ] []
        ]
    else
        -- This should never happen
        []


reviewerDataAttribute : Maybe String -> Attribute a
reviewerDataAttribute email =
    attribute "data-test-reviewer-email" (Maybe.withDefault "" email)


commitButton : CommitButton -> Node Msg
commitButton commitButton =
    button
        [ class ("small test-button" ++ " " ++ commitButton.class)
        , onClickWithPreventDefault (not commitButton.openCommitOnGithub) commitButton.msg
        ]
        [ i [ class ("fa" ++ " " ++ commitButton.iconClass) ] []
        , text " "
        , text commitButton.name
        ]


commitClassList : Model -> Commit -> Property a
commitClassList model commit =
    classList
        [ ( "commit", True )
        , ( "your-last-clicked", model.lastClickedCommitId == commit.id )
        , ( "authored-by-you", authoredByYou model commit )
        , ( "is-being-reviewed", commit.isBeingReviewed )
        , ( "is-reviewed", commit.isReviewed )
        , ( "test-is-new", commit.isNew )
        , ( "test-is-being-reviewed", commit.isBeingReviewed )
        , ( "test-is-reviewed", commit.isReviewed )
        , ( "test-commit", True )
        , ( "test-authored-by-you", authoredByYou model commit )
        ]


authoredByYou : Model -> Commit -> Bool
authoredByYou model commit =
    String.contains model.settings.name (authorName commit.authorName)


commitId : Commit -> String
commitId commit =
    "commit-" ++ toString commit.id
