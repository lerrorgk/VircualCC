#!/bin/bash

cecho(){  # source: https://stackoverflow.com/a/53463162/2886168
    RED="\033[0;31m"
    GREEN="\033[0;32m"
    YELLOW="\033[0;33m"
    # ... ADD MORE COLORS
    NC="\033[0m" # No Color

    printf "${!1}${2} ${NC}\n"
}

cecho "GREEN" "Running RDMA Network Load Balancing Simulations (leaf-spine topology)"

TOPOLOGY="fat_k4_100G_OS2" # or, fat_k8_100G_OS2
NETLOAD="50" # network load 50%
RUNTIME="0.1" # 0.1 second (traffic generation)
TRAFFIC_GEN_METHOD="simple_alltoall" # or, random

cecho "YELLOW" "\n----------------------------------"
cecho "YELLOW" "TOPOLOGY: ${TOPOLOGY}" 
cecho "YELLOW" "NETWORK LOAD: ${NETLOAD}" 
cecho "YELLOW" "TIME: ${RUNTIME}" 
cecho "YELLOW" "TIME: ${TRAFFIC_GEN_METHOD}" 
cecho "YELLOW" "----------------------------------\n"

# Lossless RDMA
cecho "GREEN" "Run Lossless RDMA experiments..."
python3 run.py --lb fecmp --pfc 1 --irn 0 --simul_time ${RUNTIME} --netload ${NETLOAD} --topo ${TOPOLOGY} --traffic_gen_method ${TRAFFIC_GEN_METHOD} 2>&1 > /dev/null & 
sleep 5
# conga only for non-bond topo;
python3 run.py --lb conga --pfc 1 --irn 0 --simul_time ${RUNTIME} --netload ${NETLOAD} --topo ${TOPOLOGY} --traffic_gen_method ${TRAFFIC_GEN_METHOD} 2>&1 > /dev/null &
sleep 5
# 
python3 run.py --lb conweave --pfc 1 --irn 0 --simul_time ${RUNTIME} --netload ${NETLOAD} --topo ${TOPOLOGY} --traffic_gen_method ${TRAFFIC_GEN_METHOD} 2>&1 > /dev/null &
sleep 5
python3 run.py --lb dv --pfc 1 --irn 0 --simul_time ${RUNTIME} --netload ${NETLOAD} --topo ${TOPOLOGY} --traffic_gen_method ${TRAFFIC_GEN_METHOD} 2>&1 > /dev/null &
sleep 5


cecho "GREEN" "Runing all in parallel. Check the processors running on background!"
