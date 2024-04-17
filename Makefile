-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil 

all: clean remove install update build test

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install foundry-rs/forge-std@v1.8.1 --no-commit && forge install openzeppelin/openzeppelin-contracts@v5.0.2 --no-commit 

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

coverage :; forge coverage --report debug > coverage-report.txt

snapshot :; forge snapshot

format :; forge fmt

slither :; slither . --config-file slither.config.json 

aderyn :; aderyn .

scope :; tree ./src/ | sed 's/└/#/g; s/──/--/g; s/├/#/g; s/│ /|/g; s/│/|/g'

scopefile :; @tree ./src/ | sed 's/└/#/g' | awk -F '── ' '!/\.sol$$/ { path[int((length($$0) - length($$2))/2)] = $$2; next } { p = "src"; for(i=2; i<=int((length($$0) - length($$2))/2); i++) if (path[i] != "") p = p "/" path[i]; print p "/" $$2; }' > scope.txt

merkle :; npm run makeMerkle

proof :; npm run makeProof

deploy :; forge script --sender 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045 --account myAccount --rpc-url ${ZKSYNC_MAINNET_RPC_URL} --etherscan-api-key ${ETHERSCAN_API_KEY} --broadcast --verify
