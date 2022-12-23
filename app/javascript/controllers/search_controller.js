import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {

  connect() {
    let modal = new Modal(search_modal)
    this.search().then(users => this.set_users_in_list(users))
    search_button.addEventListener('click', () => modal.show())
    q_username_cont.addEventListener('keyup', () => {
      this.search().then(users => this.set_users_in_list(users))
    })
  }

  async search() {
    let url = new URL(window.location.origin + '/users/search')
    let params = { 'q[username_cont]': q_username_cont.value }
    url.search = new URLSearchParams(params).toString()

    return fetch(url).then(res => res.json())
      .catch(error => console.error('Error:', error))
      .then(users => users)
  }

  set_users_in_list(users) {
    let users_list_items = []
    users.forEach(user => {
      let element = document.createElement('a')
      let text = document.createTextNode(user.username)
      element.appendChild(text)
      element.classList.add('list-group-item', 'list-group-item-action')
      element.href = '/' + user.username
      users_list_items.push(element)
    })
    users_list.replaceChildren(...users_list_items);
  }
}
