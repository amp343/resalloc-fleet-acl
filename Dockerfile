FROM amp343/alpine-ruby

COPY src/Gemfile .
COPY src/Gemfile.lock .
RUN bundle install

COPY src /src

# the filesystem db should be
# removed and recreated on each up

RUN rm -f /src/db/development.sqlite3

# ENTRYPOINT ping 8.8.8.8#
ENTRYPOINT rm -f /src/tmp/pids/server.pid && bundle exec rake db:migrate && bundle exec rails s -b 0
