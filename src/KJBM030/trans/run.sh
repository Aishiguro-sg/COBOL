#!/bin/bash
set -euo pipefail

SCRIPTDIR=$(cd $(dirname $0); pwd)
PROGRAMNAME="transtype"

export ITF="../IM.txt"
export OTF="KJBM030IM.dat"
${SCRIPTDIR}/${PROGRAMNAME}
