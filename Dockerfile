# inspired by https://hub.docker.com/r/soriyath/debian-phoenixframework/~/dockerfile/

FROM debian:jessie

RUN DEBIAN_FRONTEND=noninteractive set -ex \
    && apt-get update \
    && apt-get install -y wget build-essential python

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y locales locales-all \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    && printf 'LANG=en_US.utf8\nLANGUAGE=en_US.utf8\nLC_CTYPE="en_US.utf8"\nLC_ALL=en_US.utf8'>/etc/default/locale 

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8 

WORKDIR /usr/local/src

RUN DEBIAN_FRONTEND=noninteractive wget https://nodejs.org/dist/v5.5.0/node-v5.5.0.tar.gz \
    && tar -xzvf node-v5.5.0.tar.gz && rm -f node-v5.5.0.tar.gz \
    && cd node-v5.5.0 \
    && ./configure \
    && make \
    && make install

WORKDIR /srv/www

RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
    && DEBIAN_FRONTEND=noninteractive dpkg -i erlang-solutions_1.0_all.deb \
    && rm erlang-solutions_1.0_all.deb \
    && apt-get update \
    && apt-get install -y --fix-missing build-essential esl-erlang elixir inotify-tools \
    && mix local.hex --force

RUN DEBIAN_FRONTEND=noninteractive mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez
RUN DEBIAN_FRONTEND=noninteractive npm install -g brunch \
    && npm install

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git && mkdir -p /tmp/rebar && cd /tmp/rebar && git clone https://github.com/rebar/rebar . && make && cp rebar /usr/bin/rebar && chmod +x /usr/bin/rebar

RUN DEBIAN_FRONTEND=noninteractive apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN DEBIAN_FRONTEND=noninteractive mix phoenix.new app --force
RUN DEBIAN_FRONTEND=noninteractive cd app && mix hex.info && echo "Y" | mix deps.get --force
RUN DEBIAN_FRONTEND=noninteractive cd app && npm install && node node_modules/brunch/bin/brunch build
#RUN DEBIAN_FRONTEND=noninteractive cd app && echo "Y" | mix ecto.create

EXPOSE 4000
