import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {

  connect() {
    let modal = new Modal(search_modal)
    search_modal.addEventListener('shown.bs.modal', () => q_username_or_name_cont.focus())
    this.search().then(users => this.set_users_in_list(users))
    search_button.addEventListener('click', () => modal.show())
    q_username_or_name_cont.addEventListener('keyup', () => {
      this.search().then(users => this.set_users_in_list(users))
    })
  }

  async search() {
    let url = new URL(window.location.origin + '/users/search')
    let params = { 'q[username_or_name_cont]': q_username_or_name_cont.value }
    url.search = new URLSearchParams(params).toString()

    return fetch(url).then(res => res.json())
      .catch(error => console.error('Error:', error))
      .then(users => users)
  }

  set_users_in_list(users) {
    let users_list_items = []
    users.forEach(user => {
      let user_item = this.generete_user_item_for_list(user)
      users_list_items.push(user_item)
    })
    users_list.replaceChildren(...users_list_items);
  }

  generete_user_item_for_list(user) {
    let user_item = document.createElement('a')

    let p_tag = document.createElement('p')
    p_tag.appendChild(document.createTextNode(user.name))
    p_tag.classList.add('mb-0', 'fw-bold')

    let em_tag = document.createElement('em')
    em_tag.appendChild(document.createTextNode(user.username))

    user_item.appendChild(p_tag)
    user_item.appendChild(em_tag)

    user_item.classList.add('list-group-item', 'list-group-item-action')
    user_item.href = '/' + user.username

    return user_item
  }
}
