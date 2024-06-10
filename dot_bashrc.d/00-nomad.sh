#!/bin/bash

func nomad-varsync-pull() {
  nomad namespace list -json | jq -r '.[].Name' | while read namespace; do
    nomad var list -namespace "$namespace" -out json | jq -r '.[].Path' | while read key; do
      mkdir -p $(dirname "$PWD/nomad-vars/$namespace/$key")
      nomad var get -namespace "$namespace" -out hcl "$key" > "$PWD/nomad-vars/$namespace/${key}.hcl"
    done
  done
}

func nomad-varsync-push() {
  find nomad-vars -type f | sed 's/^[^/]*\///' | while read file; do
    namespace="${file%%/*}"
    key="${${file#*/}%.*}"
    echo "namespace: ${namespace} key: ${key}"
    ls -al "$PWD/nomad-vars/$namespace/${key}.hcl"
    cat "$PWD/nomad-vars/$namespace/${key}.hcl" | nomad var put -namespace "$namespace" -in hcl "$key" -
  done
}
