#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

firstParam=${1:-}
if [ "$firstParam" = "help" -o "$firstParam" = "--help" -o "$firstParam" = "-h" ]; then
  echo "Runs AAXtoMP3 app in docker container (building image if needed) to batch convert"
  echo "  a directory of AAX files to MP3"
  echo "Usage: $0 <activationBytes> <audiobookDir>" 
  echo "   eg: $0 a5c68103 /path/to/audiobooks" 
  exit
fi

cryptoKey=$firstParam
if [ -z "$cryptoKey" ]; then
  echo "ERROR: first param must be the activation bytes, e.g. a5c68103"
  exit 1
fi

audiobookDir=${2:-}
if [ -z "$audiobookDir" ] || [ ! -d "$audiobookDir" ]; then
  echo "ERROR: second param must be directory of audiobooks (.aax files)"
  exit 1
fi

dockerImageName=local/aax-to-mp3
if 
  ! docker images --format "{{.Repository}}" | grep -q "^${dockerImageName}$" ||
  [ "${FORCE_BUILD:-}" = "1" ]
then
  echo "Docker image doesn't exist, building..."
  docker build -t $dockerImageName .
fi

docker run \
  --rm \
  -it \
  -e AUDIBLE_ACTIVATION_BYTES="$cryptoKey" \
  -v "$audiobookDir":/target \
  -u "$(id -u):$(id -g)" \
  $dockerImageName
