shopt -s nullglob

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for file in ./git*.sh; do
    source "$file"
done

shopt -u nullglob
