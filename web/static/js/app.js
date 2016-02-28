// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import {Socket} from "phoenix"

// Generic elm app code, works with render_elm in PageView
window.elmApps = {};
var elmAppElements = document.getElementsByClassName("js-elm-app");

for(var i = 0; i < elmAppElements.length; i += 1) {
  var element = elmAppElements[i];
  var appName = element.dataset.appName;
  var options = JSON.parse(atob(element.dataset.options));

  window.elmApps[appName] = Elm.embed(Elm[appName], element, options);
}

var savedSettingsJson = Cookies.get("settings");

// Specific code for CommitList
if(elmApps.CommitList) {
  // Set up websocket
  let socket = new Socket("/socket", { params: { auth_key: window.authKey } })
  socket.connect()
  let channel = socket.channel("commits", {})
  channel.join()

  // Connect Elm app to websockets
  var app = elmApps.CommitList;
  channel.on("updated_commit", (commit) => app.ports.updatedCommit.send(commit))

  app.ports.outgoingCommands.subscribe((event) => {
    var action = event[0];
    var change = event[1];
    channel.push(action, change)
  })

  // Load settings
  if(savedSettingsJson) { app.ports.settings.send(JSON.parse(savedSettingsJson)) }
}

// Persist changes to settings
if(elmApps.Settings) {
  var app = elmApps.Settings;

  if(savedSettingsJson) { app.ports.settings.send(JSON.parse(savedSettingsJson)) }

  app.ports.settingsChange.subscribe((settings) => {
    Cookies.set("settings", JSON.stringify(settings))
  })

  // We don't show anything until we're fully initialized to avoid
  // a flicker of the settings page without any loaded settings.
  app.ports.initialized.send(true);
}
