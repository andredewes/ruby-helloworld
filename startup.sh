#!/usr/bin/env bash

if [ -n "$RAILS_ENV" ]
  then
    echo "RAILS_ENV set to $RAILS_ENV"
  else
    echo 'RAILS_ENV not set, default to production'
    export RAILS_ENV='production'
fi

if [ $# -ne 0 ]
  then
    echo "Executing custom startup: $@"
    echo "$@" > /opt/startup/startupCommand
    STARTUPCOMMAND=$(cat /opt/startup/startupCommand)
    
    echo "Running $STARTUPCOMMAND"
    eval "$STARTUPCOMMAND"
fi

echo "Working folder: $(pwd)"
echo "defaulting to command: \"bundle exec rails server -e $RAILS_ENV -p $PORT\""
bundle exec rails server -b 0.0.0.0 -e "$RAILS_ENV" -p "$PORT"