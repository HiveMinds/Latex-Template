#!/bin/bash
# compiles the latex report in project 6. Run from /latex/project6/ directory.

source src/cli_logging.sh
source src/helper_dir_and_files.sh
source src/helper_postprocessing.sh
source src/helper_tex_to_pdf.sh
source src/install_apt.sh
source src/ubuntu_prerequisites.sh
source src/uninstall_apt.sh

## Specify global variables that are used in this script.
REPORT_FILENAME="main"
REL_PATH_CONTAINING_MAIN_TEX="latex"
REL_MAIN_TEX_FILEPATH="$REL_PATH_CONTAINING_MAIN_TEX/$REPORT_FILENAME.tex"

OUTPUT_DIR="output"
OUTPUT_PATH="$REL_PATH_CONTAINING_MAIN_TEX/$OUTPUT_DIR"

assert_os_is_supported
install_prerequisites ""
assert_initial_path
prepare_output_dir
# compile_latex_into_pdf "false" "false"
compile_latex_into_pdf "false" "true"
postprocess
