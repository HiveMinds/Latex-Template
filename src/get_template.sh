#!/usr/bin/env bash
LATEX_DIR="latex"
TEMPLATE_REPO_NAME="University-LaTex-Templates"

# Dirs to copy and their targets
# TODO: capitalise the global variable names outside the function.
source_appendices="Appendices"
target_appendices="latex/Appendices"

source_chapters="Chapters"
target_chapters="latex/Chapters"

source_images="Images"
target_images="latex/Images"

source_style_files="style_files"
target_style_files="latex/"

main="main.tex"
target_main="latex/main.tex"

source_wordlists="Wordlists"
target_wordlists="latex/Wordlists"

# source src/get_template.sh && get_template
get_template() {
  local template_type="$1"
  local university_name="$2"

  # Create new_template_dir
  rm -r -f "$LATEX_DIR"

  # TODO: assert dir not exists.
  mkdir "$LATEX_DIR"
  # TODO: assert dir exists.

  # Curl the template folder from git.
  # local repo_url_without_https="github.com/HiveMinds/"
  local repo_url_without_https="https://github.com/HiveMinds/$TEMPLATE_REPO_NAME.git"
  # local repo_url_without_https="github.com/HiveMinds/University-LaTex-Templates.git"
  if [ ! -d "$TEMPLATE_REPO_NAME" ]; then
    git clone "$repo_url_without_https"
  fi
  if [ ! -d "$TEMPLATE_REPO_NAME/$template_type" ]; then
    echo "Error, desired template:$template_type did not exist (yet)."
    exit 5
  fi
  if [ ! -d "$TEMPLATE_REPO_NAME/$template_type/$university_name" ]; then
    echo "Error, desired university template:$template_type/$university_name did not exist (yet)."
    exit 5
  fi

  cp -a "$TEMPLATE_REPO_NAME/$template_type/$university_name/." "latex/"

  # TODO: Compile the latex and verify it worked. (Checksum of pdf.)
}
