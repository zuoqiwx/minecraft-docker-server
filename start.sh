#!/bin/bash

# CLI options
init_only=0
saving_server_opts=0
extra_server_opts=""
while [ $# -gt 0 ]; do
    key="$1"
    case $key in
    --init-only)
        init_only=1
        ;;
    --)
        saving_server_opts=1
        ;;
    *)
        if [ "$saving_server_opts" -eq 1 ]; then
            extra_server_opts="$extra_server_opts $key"
        fi
        ;;
    esac
    shift
done

# dependencies
uname -a
java --version

# files and dirs
server_jar="../bin/server-1.19.3.jar"
server_data_dir="server"
if [ ! -d "$server_data_dir" ]; then
    echo "Error: Server data directory does not exist"
    exit 1
fi
cd $server_data_dir || exit 1

# init server
if [ "$init_only" -eq 1 ]; then
    echo "Initializing server only..."
    java -jar "$server_jar" --initSettings
    sed -i "s/^eula=.*$/eula=true/g" eula.txt
    exit 0
fi

# JVM options
memory_opts="-Xmx$JVM_MEMORY_MAX -Xms$JVM_MEMORY_START"
aikar_opts="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"
jvm_opts="$memory_opts $aikar_opts"

# run server
echo "Starting server..."
java $jvm_opts -jar "$server_jar" --nogui $SERVER_OPTS $extra_server_opts
