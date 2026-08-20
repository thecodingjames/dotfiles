# https://firefox-admin-docs.mozilla.org/reference/policies/

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
policies=$(cat $here/policies.json)

as_root <<_
mkdir -p /etc/firefox/policies

echo "$policies" >> /etc/firefox/policies/policies.json
_
