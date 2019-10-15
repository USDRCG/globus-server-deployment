#!/bin/bash

# This should be run as root as we need to interact with yum a lot.
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root"
    exit -1
fi

# set up variables
EPEL_LATEST="https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"
GLOBUS_TOOLKIT="http://downloads.globus.org/toolkit/gt6/stable/installers/repo/rpm/globus-toolkit-repo-latest.noarch.rpm"

# Install EPEL
curl -JLO "$EPEL_LATEST"
yum install -y $(basename "$EPEL_LATEST")
rm -f $(basename "$EPEL_LATEST")

# Install globus toolkit
curl -JLO "$GLOBUS_TOOLKIT"
yum install -y $(basename "$GLOBUS_TOOLKIT")
rm -f $(basename "$GLOBUS_TOOLKIT")

# Enable the proper repos for Globus Server 5 and Toolkit 6
yum-config-manager --enable -y Globus-Connect-Server-5-Stable
yum-config-manager --enable -y Globus-Toolkit-6-Stable

# Need to install plugin priorities to make sure dependencies are actually installe
yum install -y yum-plugin-priorities

# Finally, install Globus Server 5
yum install -y globus-connect-server53
