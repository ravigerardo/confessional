import { Controller } from "@hotwired/stimulus"
import consumer from '../channels/consumer';

export default class extends Controller {
  static targets = ["message"]
  suscription

  connect() {
    this.conectChanel()
    console.log(consumer.subscriptions)
    messages.scroll({ top: messages.scrollHeight })
  }

  receivedMessage(new_message) {
    let value = document.createTextNode(new_message.message)
    let p = document.createElement("p")
    p.appendChild(value)
    p.classList.add('message')
    message.value = ''
    messages.append(p)
    messages.scroll({ top: messages.scrollHeight })
    console.log(consumer.subscriptions)
  }

  conectChanel() {
    this.suscription = consumer.subscriptions.create(
      { channel: "ChatChannel", uid: chat_uid.value, token: current_user_username.value },
      { received: (data) => { this.receivedMessage(data) } }
    )
  }

  disconnect() {
    consumer.subscriptions.remove(this.suscription)
  }
}
