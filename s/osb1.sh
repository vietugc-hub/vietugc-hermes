#!/bin/bash
# Alibaba OpenSandbox step 1: config + start server (loopback), log ~/osb.txt
export PATH="$HOME/.local/bin:$PATH"
exec > ~/osb.txt 2>&1
id | tr ',' '\n' | grep -E "docker" || echo "NOT_IN_DOCKER_GROUP_YET"
uvx opensandbox-server init-config ~/.sandbox.toml --example docker
echo "--- config (non-secret lines)"
grep -v -i -E "key|token|secret|password" ~/.sandbox.toml | grep -v '^#' | grep -v '^$' | head -40
echo OSB1_DONE
