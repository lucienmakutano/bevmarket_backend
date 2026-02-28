#!/bin/bash

# Generate production SECRET_KEY_BASE for BevMarket Backend
# Usage: ./bin/generate-secret-key.sh

if command -v openssl &> /dev/null; then
    SECRET=$(openssl rand -hex 32)
    echo "Generated SECRET_KEY_BASE:"
    echo "$SECRET"
    echo ""
    echo "Set this as an environment variable in your deployment:"
    echo "  export SECRET_KEY_BASE='$SECRET'"
    echo ""
    echo "Or in Docker:"
    echo "  docker run -e SECRET_KEY_BASE='$SECRET' ..."
    echo ""
    echo "Or in Azure Container Instances/App Service:"
    echo "  az container create ... --environment-variables SECRET_KEY_BASE='$SECRET' ..."
else
    echo "Error: openssl not found. Please install openssl or install Ruby and use:"
    echo "ruby -e \"puts SecureRandom.hex(32)\""
fi
