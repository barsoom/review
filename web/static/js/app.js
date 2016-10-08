// Auto reload the app in dev, related to "config.paths.watched".
import "phoenix_html"

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
import {Socket} from "phoenix"
let socket = new Socket("/socket", { params: { auth_key: window.authKey } })
socket.connect()

// Connection status
// Could probably be made cleaner in Elm, but the important thing
// is that we know if we're connected.
let pingChannel = socket.channel("ping", {})
pingChannel.join().receive("ok", (_) => { ports.connectionStatus.send(true) })
let lastPingTime = 0
let oldConnectionStatus = false
let pingTime = 0
pingChannel.on("ping", (_) => { lastPingTime = pingTime })
setInterval((_) => {
  pingTime = Date.now() / 1000.0
  let newConnectionStatus = (pingTime - lastPingTime < 2)

  if(newConnectionStatus != oldConnectionStatus) {
    oldConnectionStatus = newConnectionStatus
    ports.connectionStatus.send(newConnectionStatus)
  }
}, 250)

// Handle disconnected clients and updates
let revision = null
pingChannel.on("welcome", (welcome) => {
  if(!revision) { revision = welcome.revision }
  if(revision != welcome.revision) { window.location.reload() }
})

// Connect Elm app to websockets
let channel = socket.channel("review", {})
channel.join()
channel.on("new_or_updated_commit", (commit) => ports.newOrUpdatedCommit.send(commit))
channel.on("new_or_updated_comment", (comment) => ports.newOrUpdatedComment.send(comment))
channel.on("welcome", (data) => {
  ports.commits.send(data.commits)
  ports.comments.send(data.comments)
})
ports.outgoingCommands.subscribe((event) => {
  var action = event[0];
  var change = event[1];
  channel.push(action, change)
})

// Load and save settings
var settingsCookieName = "settings-v2"
var savedSettingsJson = Cookies.get(settingsCookieName);
if(savedSettingsJson) {
  let data = JSON.parse(savedSettingsJson)

  // Upgrade old settings data (remove after nov 2016)
  if(data.showAllResolvedCommits == undefined) {
    data.showAllResolvedCommits = false
  }

  ports.settings.send(data)
}
ports.settingsChange.subscribe((settings) => {
  // expires is number of days
  Cookies.set(settingsCookieName, JSON.stringify(settings), { expires: 999999 })
})

// Set up some basic URL history support
ports.navigate.subscribe((path) => { window.history.pushState({}, "", path + window.location.search); })
let updateLocation = (_) => { ports.location.send(window.location.pathname) }
window.onpopstate = updateLocation
updateLocation()

// Helpers for things that are just simpler to do in JS
ports.focusCommitById.subscribe((id) => { document.getElementById("commit-" + id).scrollIntoView(true); })
