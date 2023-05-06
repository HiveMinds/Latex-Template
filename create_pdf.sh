#!/bin/bash
# compiles the latex report in project 6. Run from /latex/project6/ directory.

source src/cli_logging.sh
source src/helper_dir_and_files.sh
source src/install_apt.sh
source src/uninstall_apt.sh
source src/ubuntu_prerequisites.sh

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

## Compiling latex project.
echo "COMPILING"

# Create some files needed for makeindex
pdflatex -output-directory="$OUTPUT_PATH $REL_PATH_CONTAINING_MAIN_TEX/$REPORT_FILENAME"

# Go into output directory to compile the glossaries
cd "$OUTPUT_PATH" || exit 6
assert_current_directory_is_output_dir "$OUTPUT_PATH"

# Compiling from root directory files
makeindex $REPORT_FILENAME.nlo -s nomencl.ist -o $REPORT_FILENAME.nls

# Glossary
#makeindex -s $REPORT_FILENAME.ist -t $REPORT_FILENAME.glg -o $REPORT_FILENAME.gls $REPORT_FILENAME.glo

# List of acronyms
#makeindex -s $REPORT_FILENAME.ist -t $REPORT_FILENAME.alg -o $REPORT_FILENAME.acr $REPORT_FILENAME.acn

# Include glossary into $REPORT_FILENAME.
#makeglossaries $REPORT_FILENAME

# Compile bibliography.
bibtex $REPORT_FILENAME

# Go back up into root directory
cd ../..
assert_is_root_dir "$REL_MAIN_TEX_FILEPATH"

# Recompile $REPORT_FILENAME to include the bibliography.
# pdflatex -output-directory=$OUTPUT_PATH latex/project$PROJECT_ID/$REPORT_FILENAME
pdflatex -output-directory=$OUTPUT_PATH "$REL_MAIN_TEX_FILEPATH"

# Recompile $REPORT_FILENAME to include acronyms, glossary and nomenclature (in TOC).
pdflatex -output-directory=$OUTPUT_PATH "$REL_MAIN_TEX_FILEPATH"

## Post processing/clean-up.
# Move pdf back into "$REL_PATH_CONTAINING_MAIN_TEX.
mv $OUTPUT_PATH/$REPORT_FILENAME.pdf "$REL_PATH_CONTAINING_MAIN_TEX/$REPORT_FILENAME.pdf"

# Clean up build artifacts.
rm $OUTPUT_PATH/$REPORT_FILENAME.*

# Clean up style files.
remove_stylefiles_to_root_dir
