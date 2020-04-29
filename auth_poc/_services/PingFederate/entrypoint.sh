#!/bin/bash
set -e

echo "PING_HOME is set to $PING_HOME"

if [ "$CLUSTER_DISCOVERY" == "EC2" ]; then
  echo "Configuring for EC2 auto-discovery..."
  # Bind to host interface rather than docker bridge
  sed -i 's/pf.cluster.bind.address=NON_LOOPBACK/pf.cluster.bind.address=match-interface:eth0/' $PING_HOME/bin/run.properties
  # Enable EC2 cluster discovery
  sed -i -e '36 s/<TCPPING/<!-- <TCPPING/' \
        -e '38 s/>/> -->/' \
        -e '95 s/<!--/ /' \
        -e '105 s/-->/ /' \
        $PING_HOME/server/default/conf/tcp.xml
  # Restrict cluster scope
  sed -i -e '100 s/tags=""/tags="PING_CLUSTER=TFDOCKER"/' \
        $PING_HOME/server/default/conf/tcp.xml
  # Increase failure detection timeouts
  sed -i -e '109 s/10000/20000/' \
        -e '110 s/1500/3000/' \
        $PING_HOME/server/default/conf/tcp.xml
fi

echo "Launching config and startup scripts in parallel"

if [ "$CLUSTER_MODE" == "ENGINE" ]; then
  echo "Preparing to run as ENGINE node"
  echo "Hosts for initial discovery are set to: $CLUSTER_DISCOVERY_NODES"
  sed -i -e 's/pf.cluster.tcp.discovery.initial.hosts=/pf.cluster.tcp.discovery.initial.hosts='"$CLUSTER_DISCOVERY_NODES"'/' \
        -e 's/pf.operational.mode=STANDALONE/pf.operational.mode=CLUSTERED_ENGINE/' $PING_HOME/bin/run.properties
  ./runtime_config.sh &
else
  echo "Preparing to run as CONSOLE node"
  sed -i 's/pf.operational.mode=STANDALONE/pf.operational.mode=CLUSTERED_CONSOLE/' $PING_HOME/bin/run.properties
  ./admin_config.sh &
fi

# Inject the environment URL into HTML templates
sed -i "s|__ENV_SERVER__|${ENV_SERVER}|" \
  /usr/share/pingfederate/server/default/conf/template/state.not.found.error.page.template.html \

echo "Running PingFederate startup script..."
$PING_HOME/bin/run.sh