#!/bin/bash
set -euo pipefail

SCRIPTDIR=$(cd $(dirname $0); pwd)
PROGRAMNAME="transtype"

export ITF="../../src/KJBM030/IM.txt"
export OTF="KJBM030IM.dat"
${SCRIPTDIR}/${PROGRAMNAME}
