if [ -z ${1+x} ]; then echo "env file not provided" && exit 1; fi
if [ -z ${2+x} ]; then echo "config destinations not provided" && exit 1; fi

# Create necessary directories
data_config_dir=$2/config
mkdir -p $data_config_dir

# Install system dependencies
apt install ufw docker.io docker-compose unzip
ufw allow 22
ufw enable

# Install NVM & Bun
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
curl -fsSL https://bun.sh/install | bash

bash setup-tooling.sh $1 $data_config_dir