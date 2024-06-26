# Setup tooling
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install 20

npm i ts-node -g
npm i pm2 -g
npm i dotenv-cli -g

if [ $? -ne 0 ]; then
  echo "Return code was not zero but $?, exiting..."
  exit 1
fi

# Setup configs
dotenv -e $1 -- bash ./setup-configs.sh $2

nginx -s reload
certbot --nginx -d admin.usemelon.co -d api.usemelon.co -d api.staging.usemelon.co

# Run docker configs

for i in $2/*compose.yml; do 
  echo "starting $i"
  dotenv -e $1 -- docker compose -f $i up& 
done