#!/bin/sh

kubectl get pods \
  --all-namespaces \
  --output json \
  | jq -r '
    [.items[] | select(
        .status.phase=="Failed"
        and .status.reason=="Terminated"
        and .status.message=="Pod was terminated in response to imminent node shutdown."
    )]
    | .[]
    | "--namespace=" + (.metadata.namespace) + " " + (.metadata.name)' \
  | xargs --no-run-if-empty -L 1 kubectl delete pod

