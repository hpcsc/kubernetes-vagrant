#!/bin/bash

if command -v java > /dev/null 2>&1; then
    echo "=== Java is already installed"
else
    echo "=== Installing default-jdk"
    apt-get update && apt-get install -y default-jdk jq
fi

java -version
