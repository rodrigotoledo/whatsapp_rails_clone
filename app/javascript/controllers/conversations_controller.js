import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    conversationId: Number,
    userId: Number
  }

  connect() {
    this.scrollToBottom()
    this.markAsRead()
  }

  scrollToBottom() {
    const messagesContainer = this.element.querySelector('.messages-container')
    messagesContainer.scrollTop = messagesContainer.scrollHeight
  }

  markAsRead() {
    fetch(`/conversations/${this.conversationIdValue}/mark_as_read`, {
      method: 'PATCH',
      headers: { 'X-CSRF-Token': document.querySelector("[name='csrf-token']").content }
    })
  }
}
