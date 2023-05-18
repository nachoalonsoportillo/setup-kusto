#!/bin/bash

set -e

# Get the path to the current script
SCRIPT_PATH="$(
  cd "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"

kusto_version=$1
tool_framework_version=$2

if [ -z "$kusto_version" ] || [ -z "$tool_framework_version" ]; then
  echo "Usage: $0 <kusto_version> <tool_framework_version>"
  exit 1
fi

directory_name="kustocli"
directory_fullpath="$SCRIPT_PATH/$directory_name"
zip_file="$directory_fullpath/$directory_name.zip"

rm -rf $directory_fullpath
mkdir -p $directory_fullpath

echo "Downloading Kusto CLI version $kusto_version"
curl -L https://www.nuget.org/api/v2/package/Microsoft.Azure.Kusto.Tools/$kusto_version >$zip_file

unzip -qq $zip_file -d $directory_fullpath

# Find all the DLLs
dlls_paths=$(find "$directory_fullpath" -name Kusto.Cli.dll)

if [ -z "$dlls_paths" ]; then
  echo "Could not find any Kusto.Cli.dll"
  exit 1
fi

echo "Looking for CLI distribution built with $tool_framework_version"
kusto_cli_path=$(echo "$dlls_paths" | { grep -m 1 $tool_framework_version || true; })

if [ -z "$kusto_cli_path" ]; then
  echo "Could not find $tool_framework_version in $dlls_paths"
  exit 1
fi

echo "Found $kusto_cli_path"

# Check if script is in the github actions environment and not in a local environment
if [ -n "$GITHUB_ENV" ]; then
  echo "Setting KUSTO_CLI_PATH environment variable"
  echo "KUSTO_CLI_PATH=$kusto_cli_path" >>$GITHUB_ENV
fi
