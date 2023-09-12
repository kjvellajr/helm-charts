#!/bin/sh

now=$(date +%Y-%m-%dT%H:%M:%SZ -d "now")
certs=$(kubectl get certificate --all-namespaces -o jsonpath='{range .items[*]}{"ERROR: Certificate "}{@.metadata.namespace}{"/"}{@.metadata.name}{" was eligible for renewal at "}{@.status.renewalTime}{"\n"}{end}')
eligible=$(printf "$certs" | awk -v now=$now '{ if ($9<now) print $0_ }')
eligible_count=$(printf "$eligible" | grep -c '^')

# echo eligible to stderr
echo "$eligible" | xargs --no-run-if-empty -L 1 echo >&2

# echo count to stdout
echo "Found $eligible_count cert(s) eligible for renewal."

# return error if we have certificates eligible for renewal
if [[ -n "$eligible" ]]; then
  exit 1
fi

exit 0
