#!/bin/sh
if [ -n "${VERSION}" ]; then
  ./linear-release sync --version "${VERSION}"
else
  ./linear-release sync
fi
