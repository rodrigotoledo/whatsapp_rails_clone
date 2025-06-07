#!/usr/bin/env bash
set -xeuo pipefail


echo ">> Running RuboCop..."
bundle exec rubocop -A

echo ">> Running Brakeman..."
bundle exec brakeman --no-pager --quiet || true

if [[ -f ./tmp/pids/server.pid ]]; then
  rm ./tmp/pids/server.pid
fi

chown -R appuser:appuser /app/db
chmod -R 775 /app/db

bundle

if [[ "${FORCE_DB_CREATE}" == "true" ]]; then
  bin/rails db:drop
  bin/rails db:drop:cache
  bin/rails db:drop:cable
  bin/rails db:drop:queue
  bin/rails db:create
  bin/rails db:create:cache
  bin/rails db:create:cable
  bin/rails db:create:queue
  touch .db-created
fi

bin/rails db:migrate

if [[ "${FORCE_DB_SEED}" == "true" ]]; then
  bin/rails db:seed
  touch /app/db/.db-seeded
fi

exec "./bin/dev"
