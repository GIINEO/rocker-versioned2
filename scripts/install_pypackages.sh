#!/bin/bash
set -e

# Setup a virtualenv to install things into

# Put things under /opt/venv, if nothing else is specified
export VIRTUAL_ENV="${VIRTUAL_ENV:=/opt/venv}"
export PATH="${VIRTUAL_ENV}/bin:${PATH}"

# Make sure that Rstudio sees these env vars too
echo "PATH=${PATH}" >>"${R_HOME}/etc/Renviron.site"
echo "VIRTUAL_ENV=${VIRTUAL_ENV}" >>"${R_HOME}/etc/Renviron.site"

python3 -m venv "${VIRTUAL_ENV}"

python3 -m pip --no-cache-dir install --upgrade --ignore-installed -r /rocker_scripts/requirements.txt

