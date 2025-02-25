// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("message-form");

  if (!form) return;
  
  form.addEventListener("submit", function (event) {
    if (!navigator.onLine) {
      event.preventDefault();
      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
      const message = {
        receiver_id: document.querySelector("[name='message[receiver_id]']")?.value || null,
        group_id: document.querySelector("[name='message[group_id]']")?.value || null,
        receiver_type: document.querySelector("[name='message[receiver_type]']")?.value || null,
        content: document.querySelector("[name='message[content]']").value,
        timestamp: new Date().toISOString(),
        csrf_token: csrfToken
      };
      
      saveMessageOffline(message);
    }
  });
  
  function saveMessageOffline(message) {
    let messages = JSON.parse(localStorage.getItem("offlineMessages")) || [];
    messages.push(message);
    localStorage.setItem("offlineMessages", JSON.stringify(messages));
    const flashNotices = document.querySelectorAll('.flash_notice, .flash_error');
    flashNotices.forEach(function (flash) {
      flash.style.display = 'none';
    });

    const offlineMessage = document.getElementById('offline_message');
    if (offlineMessage) {
      offlineMessage.style.display = 'block';
    }
  }
});



window.addEventListener('online', function() {
  let messages = JSON.parse(localStorage.getItem("offlineMessages")) || [];
  const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  if (messages.length > 0) {
    messages.forEach((message) => {
      fetch('/messages', {
        method: 'POST',
        body: JSON.stringify(message),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
      })
      .then(response => response.json())
      .then(data => {
        const flashNotices = document.querySelectorAll('.flash_notice, .flash_error');
        flashNotices.forEach(function (flash) {
          flash.style.display = 'none';
        });
        const onlineMessagesSync = document.getElementById('online_messages_sync');
        if (onlineMessagesSync) {
          onlineMessagesSync.style.display = 'block';
        }
      })
      .catch((error) => {
        console.error("Error sync:", error);
      });
    });
    localStorage.removeItem("offlineMessages");
  }
});
