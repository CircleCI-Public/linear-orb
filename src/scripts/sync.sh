#!/bin/sh
if [ -n "${VERSION}" ]; then
  ./linear-release sync --release-version "${VERSION}"
else
  ./linear-release sync
fi
