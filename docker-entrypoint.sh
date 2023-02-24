#!/usr/bin/env bash
set -euo pipefail
debugParam=
if [ "${DEBUG:-0}" = "1" ]; then
  set -x
  debugParam="--debug"
fi

completedDir=./completed
cryptoKey=${AUDIBLE_ACTIVATION_BYTES:?must be set, e.g. a5c68103}

cd /target
if [ -f MOUNT_A_VOLUME_OVER_THIS_DIR ]; then
  echo "ERROR: you need to mount a docker volume with the aax files at $PWD"
  echo "  e.g: docker run --rm -v /path/to/books:/target ..."
  exit 1
fi
set -x
mkdir -p $completedDir
ls -l

for curr in *.aax; do
  echo "Processing $curr"
  time /app/AAXtoMP3 \
    ${debugParam} \
    --complete_dir "$completedDir" \
    -A "$cryptoKey" \
    "$curr" \
    $*
  echo "Finished $curr"
done

echo "All finished :D"
