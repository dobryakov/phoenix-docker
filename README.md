# phoenix-docker
Phoenix Elixir Docker

mkdir phoenix_dev && cd phoenix_dev
git clone https://github.com/dobryakov/phoenix-docker .
git checkout baseimage # switch to baseimage branch!
docker-compose up -d
docker exec -t -i phoenixdev_app_1 bash -l
mix ecto.create
mix phoenix.server
