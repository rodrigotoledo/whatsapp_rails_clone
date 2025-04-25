#!/usr/bin/env bash
set -xeuo pipefail


echo ">> Running RuboCop..."
bundle exec rubocop || true

echo ">> Running Brakeman..."
bundle exec brakeman --no-pager --quiet || true

if [[ -f ./tmp/pids/server.pid ]]; then
  rm ./tmp/pids/server.pid
fi

bundle

if ! [[ -f .db-created ]]; then
  bin/rails db:prepare
  touch .db-created
fi

bin/rails db:migrate

if ! [[ -f .db-seeded ]]; then
  bin/rails db:seed
  touch .db-seeded
fi


foreman start -f Procfile.dev
