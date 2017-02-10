-- Somewhat overengineered (for fun and to learn more Elm) feature to encourage people
-- to finish reviews early, or abort them so other people can review.
module CommitList.Header.InReviewByYou exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import VirtualDom exposing (Node)
import Shared.Types exposing (..)
import Shared.Formatting exposing (formattedTime)
import Array
import Date


view : Model -> Node Msg
view model =
    if hasCommitInReviewByYouTooLong model then
        span []
            [ text ". "
            , text "A commit is waiting for your review since "
            , span []
                [ span [ class "in-review-by-you" ]
                    (model
                        |> charactersAndColorsForInReviewByYouLink
                        |> List.indexedMap
                            (\charIndex ->
                                \data ->
                                    let
                                        character = Tuple.first data
                                        colorIndex = Tuple.second data
                                    in
                                       renderCharacter model character charIndex colorIndex
                            )
                    )
                ]
            ]
    else
        span [] []

renderCharacter : Model -> String -> Int -> Int -> Node Msg
renderCharacter model character charIndex colorIndex =
    a
        [ href <| oldestCommitInReviewByYouUrl model
        , onClick (FocusCommitById <| oldestCommitInReviewByYouId model)
        , style
            [ ( "color", "hsla(" ++ (colorIndex |> toString) ++ ", 100%, 70%, 1)" )
            , ( "font-weight", "bold" )
            , ( "font-size", (((colorIndex |> toFloat) * 0.01 + 16) |> toString) ++ "px" )
            , ( "left", (charIndex * 8 |> toString) ++ "px" )
            ]
        ]
        [ text <| character
        ]


charactersAndColorsForInReviewByYouLink : Model -> List ( String, Int )
charactersAndColorsForInReviewByYouLink model =
    let
        characters =
            model |> oldestCommitInReviewByYouTimestamp |> stringAsListOfStrings

        colorIndexes =
            model.inReviewByYouLinkColors

        textLength =
            List.length characters |> toFloat

        colorLength =
            List.length colorIndexes |> toFloat
    in
        characters
            |> List.indexedMap
                (\index ->
                    \char ->
                        let
                            indexInColorList =
                                round ((toFloat index) * (colorLength / textLength))

                            maybeColor =
                                Array.get indexInColorList (Array.fromList (List.reverse colorIndexes))

                            color =
                                Maybe.withDefault 0 maybeColor
                        in
                            ( char, color )
                )


stringAsListOfStrings : String -> List String
stringAsListOfStrings str =
    let
        length =
            String.length str
    in
        List.range 0 (length - 1)
            |> List.map
                (\index ->
                    String.slice index (index + 1) str
                )


hasCommitInReviewByYouTooLong : Model -> Bool
hasCommitInReviewByYouTooLong model =
    not
        (commitsBeingReviewedByYouTooLong model
            |> List.isEmpty
        )


oldestCommitInReviewByYouUrl : Model -> String
oldestCommitInReviewByYouUrl model =
    let
        commit =
            commitsBeingReviewedByYouTooLong model |> List.reverse |> List.head
    in
        case commit of
            Just commit ->
                commit.url

            Nothing ->
                "If this is shown, someone forgot to ask if hasCommitInReviewByYouTooLong is true before calling this function."


oldestCommitInReviewByYouId : Model -> Int
oldestCommitInReviewByYouId model =
    let
        commit =
            commitsBeingReviewedByYouTooLong model |> List.reverse |> List.head
    in
        case commit of
            Just commit ->
                commit.id

            Nothing ->
                -1


oldestCommitInReviewByYouTimestamp : Model -> String
oldestCommitInReviewByYouTimestamp model =
    let
        commit =
            commitsBeingReviewedByYouTooLong model |> List.reverse |> List.head
    in
        case commit of
            Just commit ->
                formattedTime (Maybe.withDefault commit.timestamp commit.reviewStartedTimestamp)

            Nothing ->
                "If this is shown, someone forgot to ask if hasCommitInReviewByYouTooLong is true before calling this function."


commitsBeingReviewedByYouTooLong : Model -> List Commit
commitsBeingReviewedByYouTooLong model =
    model.commits
        |> List.filter
            (\commit ->
                let
                    -- seconds:
                    tooLongTimeInReview =
                        15 * 60

                    reviewerEmail =
                        (Maybe.withDefault "unknown" commit.pendingReviewerEmail)

                    reviewStartedTime =
                        (Maybe.withDefault "2011-01-01T00:00:00" commit.reviewStartedTimestamp) |> Date.fromString |> Result.withDefault (Date.fromTime model.currentTime) |> Date.toTime

                    isBeingReviewedByYou =
                        reviewerEmail == model.settings.email

                    reviewStartedTooLongAgo =
                        model.currentTime - reviewStartedTime > tooLongTimeInReview * 1000
                in
                    commit.isBeingReviewed
                        && isBeingReviewedByYou
                        && reviewStartedTooLongAgo
            )
