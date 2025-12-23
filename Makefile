deploy:
	@if [ -n "$$SEPOLIA_RPC_URL" ]; then \
		echo "Using Sepolia RPC"; \
		forge script script/Deploy/DeployEtherVault.s.sol --rpc-url sepolia --broadcast; \
	else \
		echo "Using Local Anvil"; \
		forge script script/Deploy/DeployEtherVault.s.sol --rpc-url local --broadcast; \
	fi
