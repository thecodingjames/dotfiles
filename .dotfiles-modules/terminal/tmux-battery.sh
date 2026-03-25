is_charging=0
charge=0

shopt -s nullglob

for battery in /sys/class/power_supply/BAT*; do

  if [[ -r "$battery/capacity" ]]; then
    now=$(<"$battery/capacity")

    (( charge += now ))
  else
    continue
  fi

  if [[ -r "$battery/status" ]]; then
    status=$(<"$battery/status")
    status=${status,,}

    if ! [[ "$status" =~ (discharging) ]]; then
      is_charging=1
    fi
  fi

done

if (( charge == 0 )); then
  # assume no battery
  exit 0
fi

style="colour28" # dark green

if (( is_charging == 0 )); then
  # discharging

  if (( charge < 30 )); then 
    style="colour1,bold" # red
  else
    style="colour208" # orange
  fi

fi

echo "#[fg=$style] $charge% "
