#!/bin/sh

# delete any pods that have failed because of a nodeshutdown
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

# delete any pods that have failed because of a nodeshutdown
kubectl get pods \
  --all-namespaces \
  --output json \
  | jq -r '
    [.items[] | select(
        .status.phase=="Failed"
        and .status.reason=="NodeShutdown"
    )]
    | .[]
    | "--namespace=" + (.metadata.namespace) + " " + (.metadata.name)' \
  | xargs --no-run-if-empty -L 1 kubectl delete pod

# delete any pods that are in terminating state and have not been deleted
kubectl get pods \
  --all-namespaces \
  --output json \
  | jq -r '
    [.items[] | select(
        .metadata.deletionTimestamp
    )]
    | .[]
    | "--namespace=" + (.metadata.namespace) + " " + (.metadata.name)' \
  | xargs --no-run-if-empty -L 1 kubectl delete pod
