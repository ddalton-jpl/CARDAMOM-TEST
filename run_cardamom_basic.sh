#!/bin/bash

set -e

# shellcheck disable=SC1091
source activate /opt/conda/envs/cardamom

# Determine the directory of the script
basedir=$(cd "$(dirname "$0")" && pwd -P)
OUTPUTDIR="${PWD}/output"
INPUT_FILE=$(ls -d input/*)

mkdir -p ${OUTPUTDIR}

"${basedir}/BASH/CARDAMOM_COMPILE.sh"

echo "WRITING OUTPUT NC FILE"

"${basedir}/C/projects/CARDAMOM_MDF/CARDAMOM_MDF.exe" "${INPUT_FILE}" "${OUTPUTDIR}/output_param_file_basic.cbr"

"${basedir}/C/projects/CARDAMOM_GENERAL/CARDAMOM_RUN_MODEL.exe" "${INPUT_FILE}" "${OUTPUTDIR}/output_param_file_basic.cbr" "${OUTPUTDIR}/output_file_basic.nc" || true
