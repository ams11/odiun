odiun project
=====

HipChat chatroom: https://odiun.hipchat.com/chat
Travis CI: runs in the 'ci' environment; https://travis-ci.org/ams11/odiun/builds
Staging (heroku): runs in the 'staging' environment; http://odiun-staging.herokuapp.com/

Running tests:

    RAILS_ENV=test rake db:create           # if necessary
    RAILS_ENV=test rake db:migrate          # if necessary
    bundle exec rspec
