import { Controller } from "@hotwired/stimulus";
import { put } from "@rails/request.js";

export default class extends Controller {
  connect() {
    this.scrollToBottom();
    this.element.addEventListener("scroll", this.checkScroll.bind(this));
  }

  async checkScroll() {
    const { scrollTop, scrollHeight, clientHeight } = this.element;

    // Se a rolagem chegou ao final da div
    if (scrollTop + clientHeight >= scrollHeight - 5) {
      await this.markAsRead();
    }
  }

  async markAsRead() {
    const response = await put("/messages/mark_as_read", {
      headers: { "Content-Type": "application/json" },
    });

    if (response.ok) {
      const html = await response.text;
      document.getElementById("unread_messages").innerHTML = html;
    }
  }

  scrollToBottom() {
    this.element.scrollTop = this.element.scrollHeight;
  }
}
