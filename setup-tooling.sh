# Setup tooling
. /root/.bashrc
nvm install 20

npm i ts-node -g
npm i pm2 -g
npm i dotenv-cli -g

if [ $? -ne 0 ]; then
  echo "Return code was not zero but $?, exiting..."
  exit 1
fi

# Setup configs
dotenv -e $1 -- bash ./setup-configs.sh $data_config_dir

# Run docker configs

for i in *compose.yml; do 
  echo "starting $i"
  dotenv -e $1 -- docker-compose -f $i up& 
done