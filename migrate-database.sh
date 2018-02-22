#!/bin/bash
set -e

echo "Executing bundle exec 'rake db:migrate' ..."
bundle exec rake db:migrate