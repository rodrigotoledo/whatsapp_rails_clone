# Rails Application with Offline Functionality

This is a Rails application that supports offline capabilities. When the user is offline, data (such as messages) is saved locally in the browser's localStorage. Once the user is back online, the data is synchronized with the PostgreSQL database.

## Features

- Offline Mode: When the user is offline, form data is saved locally in the browser.
- Synchronization: Data is synchronized with the server and PostgreSQL database when the user goes online.
- CSRF Protection: The application uses CSRF tokens to protect against cross-site request forgery attacks.

## Setup

1 - Clone from server

```bash
git clone https://github.com/rodrigotoledo/whatsapp_rails_clone.git
```

2 - Bundle install

```bash
bundle install
```

3 - Create database and migrate

```bash
rails db:create db:migrate db:seed
```

4 - Access localhost from http://localhost:3000

## Offline Functionality

### Saving Data Offline

- When the user is offline, the application intercepts the form submission.
- The form data (e.g., message content) is stored in the browser’s localStorage.

### Synchronizing Data with PostgreSQL

- Once the user comes back online, the application attempts to sync the offline data with the server.
- The saved data is sent to the server using the POST request and stored in the PostgreSQL database.

### CSRF Token Handling

- The application automatically includes the CSRF token with requests to ensure the data is submitted securely.
- If offline, the CSRF token is saved locally and included when syncing with the server.