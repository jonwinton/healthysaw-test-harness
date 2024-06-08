#!/bin/sh

request() {
  curl -X POST -d "$1" \
    -H 'Content-Type: application/json' \
    -H "kh-run-uuid: $KH_RUN_UUID" \
    "$KH_REPORTING_URL" -v
}

reportErrorAndExit() {
  request '{"ok": false, "errors":["'"${1}"'"]}'
  exit 0
}

reportSuccessAndExit() {
  request '{"ok": true, "errors":[]}'
  exit 0
}

# Check if the pod is running
chainsaw test --no-color \
  --test-dir /chainsaw-tests \
  --report-name report \
  --report-format XML \
  "$@"
if [ "$?" -ne 0 ]; then
  reportErrorAndExit "done with failures"
fi

# If we get here, the test passed
reportSuccessAndExit