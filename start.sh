#!/bin/sh
# poor man's reloader.
# re-starts rambler when he dies of an error.

until /usr/bin/env coffee server.coffee; do
    echo "Rambler crashed with exit code $?. respawning.." >&2
    sleep 1
done
