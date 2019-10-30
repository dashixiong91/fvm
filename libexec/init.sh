#!/usr/bin/env bash
set -e

for element in `fvm init`
do
  export $element
done
