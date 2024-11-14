#!/bin/bash

set -e

## build ARGs
NCPUS=${NCPUS:--1}

install2.r --error --skipinstalled -n "$NCPUS" \
    titanic \
    psych

rm -rf /tmp/downloaded_packages

## Strip binary installed lybraries from RSPM
## https://github.com/rocker-org/rocker-versioned2/issues/340
strip /usr/local/lib/R/site-library/*/libs/*.so

echo -e "\nInstall analytics packages ver.4.4.0.4, done!"
