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
  var options = JSON.parse(element.dataset.options);

  window.elmApps[appName] = Elm[appName].embed(element);

  for(let key in options) {
    let port = window.elmApps[appName].ports[key]

    if(port) {
      port.send(options[key]);
    } else {
      throw "render_elm for '" + appName + "' was called with an argument named '" + key + "', which isn't available as a port!"
    }
  }
}

var app = elmApps.Main;
var ports = app.ports;

// Set up websocket
let socket = new Socket("/socket", { params: { auth_key: window.authKey } })
socket.connect()
let channel = socket.channel("commits", {})
channel.join().receive("ok", (_) => { ports.connectionStatus.send(true) })

// Handle disconnected clients and updates
let revision = null
channel.on("welcome", (welcome) => {
  if(!revision) { revision = welcome.revision }
  if(revision != welcome.revision) { window.location.reload() }

  ports.commits.send(welcome.commits)
  ports.comments.send(welcome.comments)
})

// Connection status
// Could probably be made cleaner in Elm, but the important thing
// is that we know if we're connected.
let lastPingTime = 0
let oldConnectionStatus = false
let pingTime = 0
channel.on("ping", (_) => { lastPingTime = pingTime })
setInterval((_) => {
  pingTime = Date.now() / 1000.0
  let newConnectionStatus = (pingTime - lastPingTime < 2)

  if(newConnectionStatus != oldConnectionStatus) {
    oldConnectionStatus = newConnectionStatus
    ports.connectionStatus.send(newConnectionStatus)
  }
}, 250)

// Connect Elm app to websockets
channel.on("updated_commit", (commit) => ports.updatedCommit.send(commit))

ports.outgoingCommands.subscribe((event) => {
  var action = event[0];
  var change = event[1];
  channel.push(action, change)
})

// Load settings
var settingsCookieName = "settings-v2"
var savedSettingsJson = Cookies.get(settingsCookieName);
if(savedSettingsJson) { ports.settings.send(JSON.parse(savedSettingsJson)) }

// Store setting changes
ports.settingsChange.subscribe((settings) => {
  Cookies.set(settingsCookieName, JSON.stringify(settings))
})

// Set up some basic URL history support
ports.navigate.subscribe((path) => { window.history.pushState({}, "", path + window.location.search); })
let updateLocation = (_) => { ports.location.send(window.location.pathname) }
window.onpopstate = updateLocation
updateLocation()
