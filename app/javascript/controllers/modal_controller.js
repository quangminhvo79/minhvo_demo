import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
    this.element.querySelectorAll('.modal-close').forEach(element => {
      element.addEventListener('click', this.close.bind(this))
    })
    this.open()
  }

  open() {
    this.element.parentElement.classList.add('active')
  }

  close() {
    document.querySelector('#modal').classList.remove('active')
  }

  disconnect() {
    this.close();
  }
}
