# phoenix-docker
Phoenix Elixir Docker

mkdir phoenix_dev && cd phoenix_dev

git clone https://github.com/dobryakov/phoenix-docker .

git checkout baseimage # switch to baseimage branch!

docker-compose up -d

docker exec -t -i phoenixdev_app_1 bash -l

cd /srv/www/app

mix deps.get

mix ecto.create (optional, because this example assumes that database software is installed in another docker container)

npm install (optional)

mix phoenix.server
