import { Controller } from "@hotwired/stimulus"
import consumer from '../channels/consumer';

export default class extends Controller {
  connect() {
    this.conectChanel();
  }

  conectChanel() {
    consumer.subscriptions.create({ channel: "ChatChannel", uid: chat_uid.value, token: "Hola" });
  }
}
