#!/usr/bin/env bash
# usage: ./who-owns-neo4j-clients.sh gowish-develop-neo4j-connections.json

FILE=${1:?path to JSON file}
echo "Reading connections from $FILE"

# 1) pull unique client IPs (strip the port) ---------------------------------
ips=$(jq -r '.[].clientAddress | split(":")[0]' "$FILE" | sort -u)

# 2) look each IP up in pods first, then services ----------------------------
for ip in $ips; do
  echo "▶︎ $ip"
  if pod=$(kubectl get pods -A -o wide --no-headers | \
           awk -v ip="$ip" '$7==ip {print $2" (ns="$1")"}'); then
    if [[ -n $pod ]]; then
      echo "    pod ➜ $pod"
      continue
    fi
  fi

  if svc=$(kubectl get svc -A -o wide --no-headers | \
           awk -v ip="$ip" '$4==ip {print $2" (ns="$1")"}'); then
    if [[ -n $svc ]]; then
      echo "    svc ➜ $svc"
      continue
    fi
  fi

  echo "    not found in pods or services"
done
