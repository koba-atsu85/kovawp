#!/bin/sh
set -x
# install mackerel-agent
mackerel_agent=/app/mackerel-agent/mackerel-agent
mackerel_agent_conf=/app/mackerel-agent/mackerel-agent.conf

cd /app/ && \
  curl -O http://file.mackerel.io/agent/tgz/mackerel-agent-latest.tar.gz && \
  tar xvfz mackerel-agent-latest.tar.gz
sh << SCRIPT
cat > $mackerel_agent_conf <<'EOF';
pidfile = "/app/mackerel-agent/mackerel-agent.pid"
root = "/app/mackerel-agent"
apikey = "8iHoGEBXGdxknsMykukaD9k6kGMbpzuJ1kj5h4937eHU"
roles = [ "kovawp:web" ]
[host_status]
on_start = "working"
EOF
SCRIPT
trap "$mackerel_agent retire -conf $mackerel_agent_conf -force" TERM
$mackerel_agent -conf $mackerel_agent_conf -v &

#web: vendor/bin/heroku-php-apache2

cd /
vendor/bin/heroku-php-apache2
