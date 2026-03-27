#! /usr/bin/env bash

# Validate your forms before pushing

set -eu

export CY_API_KEY=${CY_API_KEY:?You need a cycloid API key}
export CY_API_URL=${CY_API_URL:?You need a cycloid API url}
export CY_ORG=${CY_ORG:?Fill your current org}

cy stack forms validate .forms.yml
