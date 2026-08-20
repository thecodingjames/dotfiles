# https://firefox-admin-docs.mozilla.org/reference/policies/

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
policies_path="$here/policies.json"

as_root <<_
mkdir -p /etc/firefox/policies; \
\
cp $policies_path /etc/firefox/policies/;
_
