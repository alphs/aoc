#!/usr/bin/env bash

set -eo pipefail

SESSION_TOKEN="$(cat ./.session | tr -d '[:space:]')"

if [ -z "$SESSION_TOKEN" ]; then
        echo "Error: No SESSION_TOKEN found. " >&2
        echo "Content of .session file empty?" >&2
        exit 1
fi

YEAR=2025
DAY="${1-$(date '+%-d')}"

if ! [[ "$DAY" =~ ^[0-9]+$ ]]; then
  echo "Error: Provide a numeric day." >&2
  exit 1
fi


day_dir="day$DAY"


mkdir -p "./$day_dir"

curl --fail --progress-bar --output "$day_dir/input.txt" \
        "https://adventofcode.com/$YEAR/day/$DAY/input" \
        -H "Cookie: session=$SESSION_TOKEN"

echo "Aoc link day $DAY: https://adventofcode.com/$YEAR/day/$DAY"

