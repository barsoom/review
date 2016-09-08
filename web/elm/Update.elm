module Update exposing (update)

import Types exposing (..)
import Constants exposing (defaultCommitsToShowCount)
import Ports

update : Msg -> Model -> (Model, Cmd a)
update msg model =
  case msg of
    SwitchTab tab ->
      ({model | activeTab = tab, commitsToShowCount = defaultCommitsToShowCount},
        Ports.navigate (pathForTab tab))

    LocationChange path ->
      ({model | activeTab = (tabForPath path)}, Cmd.none)

    UpdateConnectionStatus connected ->
      ({model | connected = if connected then Yes else No}, Cmd.none)

    UpdateEnvironment name ->
      ({model | environment = name}, Cmd.none)

    UpdateSettings settings ->
      ({ model | settings = settings }, Cmd.none)

    UpdateEmail email ->
      let
        s = model.settings
        settings = { s | email = email }
      in
        ({model | settings = settings}, Ports.settingsChange settings)

    UpdateName name ->
      let
        s = model.settings
        settings = { s | name = name }
      in
        ({model | settings = settings}, Ports.settingsChange settings)

    ShowCommit id ->
      ({ model | lastClickedCommitId = id }, Cmd.none)

    UpdateCommits commits ->
      ({ model | commits = commits, commitCount = List.length commits, commitsToShowCount = defaultCommitsToShowCount }, Cmd.none)

    UpdateComments comments ->
      ({ model | comments = comments }, Cmd.none)

    -- This triggers the display of more commits after the initial page load
    -- or when changing tabs. This makes the UI feel instant.
    ListMoreCommits _ ->
      if model.activeTab == CommitsTab && model.commitsToShowCount < model.commitCount then
        ({ model | commitsToShowCount = model.commitsToShowCount + 25 }, Cmd.none)
      else
        (model, Cmd.none)

    UpdateCommit commit ->
      -- triggers when someone else updates a commit and we receive a websocket push with an update for a commit
      (updateCommitById (\_ -> commit) commit.id model, Cmd.none)

    -- no local changes so you know if you are in sync
    -- should work fine as long as network speeds are resonable
    StartReview change    -> (model, pushEvent "StartReview" change)
    AbandonReview change  -> (model, pushEvent "AbandonReview" change)
    MarkAsReviewed change -> (model, pushEvent "MarkAsReviewed" change)
    MarkAsNew change      -> (model, pushEvent "MarkAsNew" change)

pathForTab : Tab -> String
pathForTab tab =
  case tab of
    CommitsTab -> "/commits"
    CommentsTab -> "/comments"
    SettingsTab -> "/settings"

tabForPath : String -> Tab
tabForPath path =
  case path of
    "/commits" -> CommitsTab
    "/comments" -> CommentsTab
    "/settings" -> SettingsTab
    _ -> CommitsTab

pushEvent : String -> CommitChange -> Cmd a
pushEvent name change =
  Ports.outgoingCommands (name, change)

updateCommitById : (Commit -> Commit) -> Int -> Model -> Model
updateCommitById callback id model =
  let
    updateCommit commit =
      if commit.id == id then
        (callback commit)
      else
        commit
  in
     { model | commits = (List.map updateCommit model.commits)}
