#!/bin/sh
VERSION="0.7.0"

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "${OS}-${ARCH}" in
  linux-x86_64)
    BINARY="linear-release-linux-x64"
    EXPECTED_SHA256="c82e10e79ac54bfa5efff69124add2aa793d91b0d5e32c1ed56ab856eb2a7e79"
    SHASUM_CMD="sha256sum --check --strict"
    ;;
  darwin-arm64)
    BINARY="linear-release-darwin-arm64"
    EXPECTED_SHA256="6d24809d01912e2c305c2a419858ad93349da5088c854f71d8f111bc8223b38e"
    SHASUM_CMD="shasum -a 256 --check --strict"
    ;;
  darwin-x86_64)
    BINARY="linear-release-darwin-x64"
    EXPECTED_SHA256="25ced39d772d0a61922dc8b80c319f783c2700513f610b1329384d8ec52a0951"
    SHASUM_CMD="shasum -a 256 --check --strict"
    ;;
  *)
    echo "Unsupported platform: ${OS}-${ARCH}"
    exit 1
    ;;
esac

curl -fL "https://github.com/linear/linear-release/releases/download/v${VERSION}/${BINARY}" \
  -o linear-release

echo "${EXPECTED_SHA256}  linear-release" | ${SHASUM_CMD}

chmod +x linear-release
