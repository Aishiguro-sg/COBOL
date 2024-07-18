#!/bin/bash
set -euo pipefail

SCRIPTDIR=$(cd $(dirname $0); pwd)
PROGRAMNAME="transtype"

export ITF=input.txt
export OTF=result.dat
${SCRIPTDIR}/${PROGRAMNAME}
