#!/bin/bash

# Script to build and upload a Conan package
# Parameters:
#   --folder: Directory containing the Conan recipe (default: current directory)
#   --name: Name of the Conan package
#   --version: Version of the Conan package (required)
#   --user: Conan user
#   --channel: Conan channel
#   --remote: Conan remote repository (required for upload)
#   --profile_host: Host profile for cross-building (--pr:h)
#   --profile_build: Build profile for cross-building (--pr:b)

# Default values
FOLDER="."
NAME=""
VERSION=""
USER=""
CHANNEL=""
REMOTE=""
PROFILE_HOST=""
PROFILE_BUILD=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --folder)
      FOLDER="$2"
      shift 2
      ;;
    --name)
      NAME="$2"
      shift 2
      ;;
    --version)
      VERSION="$2"
      shift 2
      ;;
    --user)
      USER="$2"
      shift 2
      ;;
    --channel)
      CHANNEL="$2"
      shift 2
      ;;
    --remote)
      REMOTE="$2"
      shift 2
      ;;
    --profile_host)
      PROFILE_HOST="$2"
      shift 2
      ;;
    --profile_build)
      PROFILE_BUILD="$2"
      shift 2
      ;;
    *)
      echo "Unknown parameter: $1"
      exit 1
      ;;
  esac
done

# Check for required parameters
if [ -z "$VERSION" ]; then
  echo "Error: Version parameter is required (--version)"
  exit 1
fi
if [ -z "$FOLDER" ]; then
  echo "Error: Folder parameter is required (--folder)"
  exit 1
fi

# Change to the specified folder
cd "$FOLDER"

# Build command with conditional parameters
CREATE_CMD="conan create . --version $VERSION"
if [ ! -z "$USER" ]; then
  CREATE_CMD="$CREATE_CMD --user $USER"
fi
if [ ! -z "$CHANNEL" ]; then
  CREATE_CMD="$CREATE_CMD --channel $CHANNEL"
fi
if [ ! -z "$PROFILE_HOST" ]; then
  CREATE_CMD="$CREATE_CMD --pr:h $PROFILE_HOST"
fi
if [ ! -z "$PROFILE_BUILD" ]; then
  CREATE_CMD="$CREATE_CMD --pr:b $PROFILE_BUILD"
fi

# Execute the build command
echo "Executing: $CREATE_CMD"
eval "$CREATE_CMD"

# Upload if remote is specified
if [ ! -z "$REMOTE" ]; then
  # Upload command with conditional package name
  UPLOAD_CMD="conan upload"
  if [ ! -z "$NAME" ]; then
    UPLOAD_CMD="$UPLOAD_CMD \"$NAME*\""
  else
    UPLOAD_CMD="$UPLOAD_CMD \"*\""
  fi

  # Complete the upload command with the required remote
  UPLOAD_CMD="$UPLOAD_CMD --confirm -r $REMOTE"

  # Execute the upload command
  echo "Executing: $UPLOAD_CMD"
  eval "$UPLOAD_CMD"
fi

# Return to the original directory
cd - > /dev/null
