#!/bin/bash
echo "Started cache clearing at $(date +'%d-%m-%Y %H:%M:%S')"
sudo sysctl -w vm.drop_caches=3
echo "Finished cache clearing at $(date +'%d-%m-%Y %H:%M:%S')"
