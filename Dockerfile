FROM gcr.io/google-appengine/ruby:latest

ARG REQUESTED_RUBY_VERSION="2.6.3"

# Install any requested ruby if not already preinstalled by the base image.
# Tries installing a prebuilt package first, then falls back to a source build.

RUN apt-get update -y \
  && apt-get install -y -q gcp-ruby-$REQUESTED_RUBY_VERSION) \
  || (cd /rbenv/plugins/ruby-build \
  && apt install -y graphicsmagick \
  && git pull \
  && rbenv install -s $REQUESTED_RUBY_VERSION) \
  && rbenv global $REQUESTED_RUBY_VERSION \
  && gem install -q --no-document bundler --version $BUNDLER_VERSION \
  && apt-get clean \
  && rm -f /var/lib/apt/lists/*_*
  
ENV RACK_ENV=production \
  RAILS_ENV=production \
  RAILS_SERVE_STATIC_FILES=true
  
ENTRYPOINT []

CMD bundle exec rackup --port $PORT
