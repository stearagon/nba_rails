#!/bin/bash

 rm latest.dump
 heroku pg:backups:capture
 heroku pg:backups:download
 pg_restore --verbose --clean --no-acl --no-owner -h localhost -U SteveAragon -d nba_rails_development latest.dump
 rm latest.dump


