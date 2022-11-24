import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    document.addEventListener("trix-file-accept", (e) => {
      e.preventDefault()
    })
  }
}
