if [ -z ${1+x} ]; then echo "env file not provided" && exit 1; fi
if [ -z ${2+x} ]; then echo "config destinations not provided" && exit 1; fi

# Create necessary directories
data_config_dir=$2/config

# Install system dependencies
apt install ufw docker docker-compose unzip
ufw allow 22
ufw enable

# Install NVM & Bun
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
curl -fsSL https://bun.sh/install | bash

exec bash

nvm install 20

npm i ts-node -g
npm i pm2 -g
npm i dotenv-cli -g

# Setup configs
dotenv -e $1 -- bash ./setup-configs.sh $data_config_dir

# Run docker configs

for i in *compose.yml; do echo "starting $i" && dotenv -e $1 -- docker-compose -f $i up&; done