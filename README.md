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

## With Docker

Need To Clean All Your Docker?

```bash
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi -f $(docker images -aq)
docker system prune -a --volumes -f
docker network rm $(docker network ls -q)
rm .db-created
rm .db-seeded
rm Gemfile.lock
```

## Putting In Development Mode

Whereas It Is Necessary To Run With Your User, Run

```bash
id -u
```

And Change The Dockerfile.Development File With The Value You Found

So Build You Just Need To Run The First Time:

```bash
docker compose -f docker-compose.development.yml build
```

And To Climb The Application Rode:

```bash
docker compose -f docker-compose.development.yml up
docker compose -f docker-compose.development.yml down
docker compose -f docker-compose.development.yml run app bash
docker compose -f docker-compose.development.yml run app rails active_storage:install
```

## Migrations

To Run Migrations, Tests ... Etc, Run The App With Whatever Is Needed:

```bash
docker compose -f docker-compose.development.yml run app rails db:drop db:create db:migrate
```

## Rails Commands

Example Of Interaction Between Computer And Container:

```bash
docker compose -f docker-compose.development.yml run app rails c
docker compose -f docker-compose.development.yml run app rails g scaffold post title
docker compose -f docker-compose.development.yml run app rails g scaffold comment post:references comment:text
```

## Testing with Docker

For Tests For Example Run `Guard`:

```bash
docker compose -f docker-compose.development.yml run app bundle exec guard
```

For Migrations (Remembering That You May Need To Run Both In Development And Test):

```bash
docker compose -f docker-compose.development.yml run app rails db:migrate
```

## Putting Down

If You Want To Stop The Services:

```bash
docker compose -f docker-compose.development.yml down
```

## Putting In Development Mode Without Docker

Whereas It Is Necessary To Run With Your User, Run

```bash
id -u
```

And To Climb The Application Rode:

```bash
rails active_storage:install
```

Recompose the database:

```bash
rails db:drop db:create db:migrate db:seed
rake db:schema:dump
```

## Testing

For Tests For Example Run `Guard`:

```bash
bundle exec guard
```

## Security

It's a good practice to use annotate, brakeman and rubocop when you are developing. You can setup your own configuration using the example that exists in `.vscode.example` renaming to `.vscode`.

## Tips about tailwind

If you are using tailwind, maybe you should change the `Procfile.dev` to listen the correct address:

```Provfile.dev
web: bin/rails server -b 0.0.0.0
css: bin/rails tailwindcss:watch
```

## Production

Look for the instance ip and:

```bash
ssh ubuntu@... -i file.pem
```

Using docker

```bash
sudo usermod -aG docker $USER
newgrp docker
docker build -t app .
docker volume create upgrade_rails_8
docker run --rm -it \
  -e RAILS_MASTER_KEY="master_key_here" \
  -v upgrade_rails_8:/app/storage \
  -p 3000:3000 \
  app
```

## Git Flow

This project uses the Git Flow branching model to manage development and releases. Below are the basic commands to get started with Git Flow.

### Git Flow Branches

- **`main`**: The production-ready branch.
- **`staging`**: The staging-ready branch.
- **`develop`**: The branch where features are integrated.
- **`feature/{feature-name}`**: Branches for developing new features.
- **`release/{version}`**: Branches for preparing a new release.
- **`hotfix/{fix-description}`**: Branches for urgent fixes.

1 . Start a New Feature:

```bash
git flow feature start {feature-name}
```

2 . Finish a Feature:

```bash
git flow feature finish {feature-name}
```

Replace {feature-name} with your feature name.

3 . Start a Release:

```bash
git flow release start {version}
```

Replace {version} with the version name.

4 . Finish a Release:

```bash
git flow release finish {version}
```

5 . Start a Hotfix:

```bash
git flow hotfix start {fix-description}
```

6 . Finish a Hotfix:

```bash
git flow hotfix finish {fix-description}
```
