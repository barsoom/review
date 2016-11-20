module Main exposing (main)

import Html
import Html exposing (div, text)
import Html.Attributes exposing (classList)
import VirtualDom exposing (Node)
import Shared.Types exposing (..)
import Shared.State
import Connectivity.View
import CommitList.View
import CommentList.View
import Settings.View
import Menu.View


main : Program Never Model Msg
main =
    Html.program
        { init = ( Shared.State.initialModel, Cmd.none )
        , view = view
        , update = Shared.State.update
        , subscriptions = Shared.State.subscriptions
        }

view : Model -> Node Msg
view model =
    let
        wrapperClasses =
            classList
                [ ( "wrapper", True )
                , ( "wrapper--disconnected", model.connected /= Yes )
                ]
    in
        div []
            [ Connectivity.View.view model
            , div [ wrapperClasses ]
                [ Menu.View.view model
                , renderTabContents model
                ]
            ]


renderTabContents : Model -> Node Msg
renderTabContents model =
    case model.activeTab of
        CommitsTab ->
            CommitList.View.view model

        CommentsTab ->
            CommentList.View.view model

        SettingsTab ->
            Html.map ChangeSettings (Settings.View.view model.settings)
