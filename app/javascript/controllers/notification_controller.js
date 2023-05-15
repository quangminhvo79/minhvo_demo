import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notification"
export default class extends Controller {
  connect() {
    setTimeout(() => { this.close(); }, 15 * 1000);
  }

  onClose(e) {
    e.preventDefault();
    this.close();
  }

  close() {
    this.element.remove();
  }
}
