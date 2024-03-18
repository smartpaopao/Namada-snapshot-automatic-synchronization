#!/bin/bash

echo "Please enter the local RPC port number (default is 26657):"
read port
port=${port:-"26657"}
echo "Local RPC port set to: $port"


echo "Please enter the number of blocks after which to automatically download a snapshot (default is 1000):"
read threshold
threshold=${threshold:-1000}


while true; do

	public_rpc_height=$(curl -s 'https://namada-testnet-rpc.itrocket.net:443/status?' | jq -r '.result.sync_info.latest_block_height')
	echo "Public RPC height is: $public_rpc_height"


	local_rpc_url="http://127.0.0.1:${port}/status?"
    echo "Local RPC URL: $local_rpc_url"

	local_rpc_height=$(curl -s http://127.0.0.1:${port}/status? | jq -r '.result.sync_info.latest_block_height')
	echo "Local RPC height is: $local_rpc_height"

	local_rpc_height_threshold=$((local_rpc_height + threshold))

	backward=$((public_rpc_height - local_rpc_height))
    echo "backward: $backward"


	if [ "$public_rpc_height" -gt "$local_rpc_height_threshold" ]; then
		echo "backward too much,need download Snapshot"

		cd $HOME
		wget -O snap_namada.tar https://testnet-files.itrocket.net/namada/snap_namada.tar

		sudo systemctl stop namadad
		cp $HOME/.local/share/namada/shielded-expedition.88f17d1d14/cometbft/data/priv_validator_state.json $HOME/.local/share/namada/shielded-expedition.88f17d1d14/cometbft/priv_validator_state.json.backup
		rm -rf $HOME/.local/share/namada/shielded-expedition.88f17d1d14/db $HOME/.local/share/namada/shielded-expedition.88f17d1d14/cometbft/data
		tar -xvf $HOME/snap_namada.tar -C $HOME/.local/share/namada/shielded-expedition.88f17d1d14
		mv $HOME/.local/share/namada/shielded-expedition.88f17d1d14/cometbft/priv_validator_state.json.backup $HOME/.local/share/namada/shielded-expedition.88f17d1d14/cometbft/data/priv_validator_state.json
		rm -rf $HOME/snap_namada.tar
		sudo systemctl restart namadad

		echo "done!"


	else
		echo "do not need download Snapshot"
	fi

	sleep 14400
done

