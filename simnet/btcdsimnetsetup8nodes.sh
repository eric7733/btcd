#!/bin/sh

set -e

SIMNET_NODES_ROOT=~/btcdsimnetnodes
MASTERNODE_ADDR=127.0.0.1:19555
NODE1_ADDR=127.0.0.1:19501
NODE2_ADDR=127.0.0.1:19502

RPCUSER="USER"
RPCPASS="PASS"
WALLET_SEED="b280922d2cffda44648346412c5ec97f429938105003730414f10b01e1402eac"
WALLET_MINING_ADDR="SsWKp7wtdTZYabYFYSc9cnxhwFEjA5g4pFc" # NOTE: This must be changed if the seed is changed.

mkdir -p "${SIMNET_NODES_ROOT}/master"
mkdir  "${SIMNET_NODES_ROOT}/1"
mkdir  "${SIMNET_NODES_ROOT}/2"
mkdir  "${SIMNET_NODES_ROOT}/wallet"

# masternode.conf
cat > "${SIMNET_NODES_ROOT}/masternode.conf" <<EOF
rpcuser=${RPCUSER}
rpcpass=${RPCPASS}
simnet=1
logdir=${SIMNET_NODES_ROOT}/master/log
datadir=${SIMNET_NODES_ROOT}/master/data
listen=${MASTERNODE_ADDR}
connect=${NODE1_ADDR}
connect=${NODE2_ADDR}
# connect=${NODE3_ADDR}
# connect=${NODE4_ADDR}
# connect=${NODE5_ADDR}
# connect=${NODE6_ADDR}
# connect=${NODE7_ADDR}
miningaddr=${WALLET_MINING_ADDR}
EOF

# node1.conf
cat > "${SIMNET_NODES_ROOT}/node1.conf" <<EOF
simnet=1
logdir=${SIMNET_NODES_ROOT}/1/log
datadir=${SIMNET_NODES_ROOT}/1/data
listen=${NODE1_ADDR}
connect=${MASTERNODE_ADDR}
connect=${NODE2_ADDR}
#connect=${NODE3_ADDR}
#connect=${NODE4_ADDR}
#connect=${NODE5_ADDR}
#connect=${NODE6_ADDR}
#connect=${NODE7_ADDR}
EOF

# node2.conf
cat > "${SIMNET_NODES_ROOT}/node2.conf" <<EOF
simnet=1
logdir=${SIMNET_NODES_ROOT}/2/log
datadir=${SIMNET_NODES_ROOT}/2/data
listen=${NODE2_ADDR}
connect=${MASTERNODE_ADDR}
connect=${NODE1_ADDR}
#connect=${NODE3_ADDR}
#connect=${NODE4_ADDR}
#connect=${NODE5_ADDR}
#connect=${NODE6_ADDR}
#connect=${NODE7_ADDR}
EOF

# btcctl.conf
cat > "${SIMNET_NODES_ROOT}/btcctl.conf" <<EOF
simnet=1
rpcuser=${RPCUSER}
rpcpass=${RPCPASS}
EOF

# btcwallet.conf
cat > "${SIMNET_NODES_ROOT}/btcwallet.conf" <<EOF
simnet=1
username=${RPCUSER}
password=${RPCPASS}
appdata=${SIMNET_NODES_ROOT}/wallet
#promptpass=1
#enablevoting=1
#enableticketbuyer=1
#ticketbuyer.nospreadticketpurchases=1
#ticketbuyer.maxperblock=5
EOF

# btcctlw.conf
cat > "${SIMNET_NODES_ROOT}/btcctlw.conf" <<EOF
simnet=1
wallet=1
rpcuser=${RPCUSER}
rpcpass=${RPCPASS}
rpccert=${SIMNET_NODES_ROOT}/wallet/rpc.cert
EOF

echo "Launch the btcd simnet instances with the following config files:"
echo "btcd -C ${SIMNET_NODES_ROOT}/masternode.conf"
echo "btcd -C ${SIMNET_NODES_ROOT}/node1.conf"
echo "btcd -C ${SIMNET_NODES_ROOT}/node2.conf"
echo ""
echo "Create the wallet -- MAKE SURE TO USE THE PRINTED SEED!!!"
echo "btcwallet -C ${SIMNET_NODES_ROOT}/btcwallet.conf --create"
echo "Seed: ${WALLET_SEED}"
echo ""
echo "Launch the wallet:"
echo "btcwallet -C ${SIMNET_NODES_ROOT}/btcwallet.conf"
echo ""
echo "To interface with the master btcd node via btcctl:"
echo "btcctl -C ${SIMNET_NODES_ROOT}/btcctl.conf <command>"
echo ""
echo "To interface with the wallet via btcctl:"
echo "btcctl -C ${SIMNET_NODES_ROOT}/btcctlw.conf <command>"
echo ""
echo "To generate blocks with the CPU miner via btcctl:"
echo "btcctl -C ${SIMNET_NODES_ROOT}/btcctl.conf generate 1"
echo ""
echo "for i in \$(seq 1 1 144); do"
echo "btcctl -C ${SIMNET_NODES_ROOT}/btcctl.conf generate 1"
echo "sleep 1"
echo "done"