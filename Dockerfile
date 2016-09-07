
FROM ubuntu:16.04

WORKDIR /usr/local/src

RUN DEBIAN_FRONTEND=noninteractive set -ex \
    && apt-get update \
    && apt-get install -y git curl wget build-essential python postgresql-client locales \
    && curl -sL https://deb.nodesource.com/setup_5.x | bash - \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    && printf 'LANG=en_US.utf8\nLANGUAGE=en_US.utf8\nLC_CTYPE="en_US.utf8"\nLC_ALL=en_US.utf8'>/etc/default/locale \
#   && wget https://nodejs.org/dist/v5.5.0/node-v5.5.0.tar.gz \
#   && tar -xzvf node-v5.5.0.tar.gz \
#   && rm -f node-v5.5.0.tar.gz \
#   && cd node-v5.5.0 \
#   && ./configure \
#   && make \
#   && make install \
    && wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
    && DEBIAN_FRONTEND=noninteractive dpkg -i erlang-solutions_1.0_all.deb \
    && rm erlang-solutions_1.0_all.deb \
    && apt-get update \
    && apt-get install -y --fix-missing build-essential esl-erlang elixir inotify-tools nodejs \
    && mix local.hex --force \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8 

RUN DEBIAN_FRONTEND=noninteractive mkdir -p /tmp/rebar \
    && cd /tmp/rebar \
    && git clone https://github.com/rebar/rebar . \
    && make \
    && cp rebar /usr/bin/rebar \
    && chmod +x /usr/bin/rebar

WORKDIR /srv/www

RUN DEBIAN_FRONTEND=noninteractive mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez \
    && mix phoenix.new app \
    && npm install -g brunch \
#   && npm install \
    && cd /srv/www/app && mix hex.info && echo "Y" | mix deps.get --force \
    && cd /srv/www/app && npm install && node node_modules/brunch/bin/brunch build

#RUN DEBIAN_FRONTEND=noninteractive cd app && echo "Y" | mix ecto.create

#EXPOSE 4000

#CMD ["/sbin/my_init"]
