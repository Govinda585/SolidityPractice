
SCRIPT = script/Deploy/DeployEtherSender.s.sol
RPC_URL = http://127.0.0.1:8545
PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
deploy-local: 
	forge script $(SCRIPT) --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY)  --broadcast



# RPC_URL_SEPOLIA = https://eth-sepolia.g.alchemy.com/v2/m1EGN2-uvdHB1eVuzHo2j
# PRIVATE_KEY_SEPOLIA =  

deploy-sepolia:
	forge script $(SCRIPT) --rpc-url $$RPC_URL_SEPOLIA --private-key $$PRIVATE_KEY_SEPOLIA --broadcast

