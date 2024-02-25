// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// <%= for y < - @max_dimension..- @max_dimension do %>
//   <div class="flex flex-row">
//     <%= for x <- -@max_dimension..@max_dimension do %>
//       <.input type="checkbox" id={"cell:#{x}.#{y}"} name={"cell:#{x}.#{y}"} phx-click={JS.push("cell_click", value:
//         %{x: x, y: y})} />
//       <% end %>
//   </div>
//   <% end %>

const reportScreenDimensionsToServer = (pushEvent) => {
  const page = document.getElementById("test")
  var checkbox = document.createElement('input');
  checkbox.type = "checkbox";
  checkbox.className = "rounded border-zinc-300 text-zinc-900 focus:ring-0 m-0"
  page.append(checkbox)
  let cellHeight = checkbox.clientHeight;
  let cellWidth = checkbox.clientWidth;
  var windowHeight = window.innerHeight;
  let windowWidth = window.innerWidth;


  let dimensions = { x: Math.floor(windowWidth / cellWidth), y: Math.floor(windowHeight / cellHeight) }
  pushEvent("screen_dimensions", dimensions)
  page.remove(checkbox)
  return dimensions;
}

const setupCheckboxes = ({ x: maxX, y: maxY }, pushEvent) => {
  const page = document.getElementById("page")
  for (let y = -maxY; y < maxY; y++) {
    for (let x = -maxX; x < maxX; x++) {
      var checkbox = document.createElement('input');
      checkbox.type = "checkbox";
      checkbox.name = "name";
      checkbox.value = "value";
      checkbox.id = `cell:${x}.${y}`;
      checkbox.className = "rounded border-zinc-300 text-zinc-900 focus:ring-0 m-0"
      checkbox.onclick = () => {
        console.log({ x, y })
        pushEvent("cell_click", { x, y })
      }
      page.append(checkbox)
    }
    page.append(document.createElement("br"))
  }
}

const setupMenuCheckbox = (pushEvent) => {
  const page = document.getElementById("page")
  var checkbox = document.createElement('input');
  checkbox.type = "checkbox";
  checkbox.name = "name";
  checkbox.value = "value";
  checkbox.id = `menu`;
  checkbox.className = "rounded border-zinc-300 text-zinc-900 focus:ring-0 m-0"
  checkbox.onclick = () => {
    pushEvent("menu_click", {})
  }
  page.append(checkbox)
}

let Hooks = {};

Hooks.ConwayPage = {
  // page() { return this.el.dataset.page },
  mounted() {
    const dimensions = reportScreenDimensionsToServer((str, payload) => this.pushEvent(str, payload))

    // this.pending = this.page()
    // window.addEventListener("scroll", e => {
    //   if (this.pending == this.page() && scrollAt() > 90) {
    //     this.pending = this.page() + 1
    //     this.pushEvent("load-more", {})
    //   }
    // })
    setupCheckboxes({ x: dimensions.x / 2, y: dimensions.y / 2 }, (str, payload) => this.pushEvent(str, payload))
  },
  // updated() { this.pending = this.page() }
}

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
})

window.addEventListener("phx:apply_tick", (e) => {
  e.detail.kill.forEach(arr => { let el = document.getElementById(`cell:${arr[0]}.${arr[1]}`); if (el != null) el.checked = false; })
  e.detail.spawn.forEach(arr => { let el = document.getElementById(`cell:${arr[0]}.${arr[1]}`); if (el != null) el.checked = true; })
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

