#!/bin/bash
# This script detects platform and architecture, then downloads and installs the matching Deep Security Agent package
 if [[ $(/usr/bin/id -u) -ne 0 ]]; then echo You are not running as the root user.  Please try again with root privileges.;
    logger -t You are not running as the root user.  Please try again with root privileges.;
    exit 1;
 fi;
  if type curl >/dev/null 2>&1; then
    SOURCEURL='https://10.216.13.32:4119'
  if [ -f "/etc/cas_cvk-version" ]; then
    curl $SOURCEURL/software/deploymentscript/platform/linux/ -o /tmp/DownloadInstallAgentPackage --insecure
  else
    curl $SOURCEURL/software/deploymentscript/platform/linux/ -o /tmp/DownloadInstallAgentPackage --insecure --silent --tlsv1.2
 fi

  if [ -s /tmp/DownloadInstallAgentPackage ]; then
    if echo '584F09EE5DCE6E3B03BCD94798AD3940508D80F91C975914F9CB33F3212CBFF7  /tmp/DownloadInstallAgentPackage' | sha256sum -c; then
      . /tmp/DownloadInstallAgentPackage
      Download_Install_Agent
    else
      echo "Failed to validate the agent installation script."
      logger -t Failed to validate the agent installation script
      false
    fi
  else
     echo "Failed to download the agent installation script."
     logger -t Failed to download the Deep Security Agent installation script
     false
  fi
else 
  echo Please install CURL before running this script
  logger -t Please install CURL before running this script
  false
fi
sleep 15
if [ -f "/etc/cas_cvk-version" ];then
	echo "[CAS] Agent-Initiated Activation"
	/opt/dsa_host/dsa_control -r
	/opt/dsa_host/dsa_control -a dsm://10.216.13.32:4120/ "policyid:9"
else
	/opt/ds_agent/dsa_control -r
	/opt/ds_agent/dsa_control -a dsm://10.216.13.32:4120/ "policyid:9"
fi;
