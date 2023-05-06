#!/bin/bash

## Specify the functions that are used in this script.
#######################################
# Checks if directory/path exists, throws error if it does not exist.
# Local variables:
# dir
# Globals:
#  None.
# Arguments:
#  dir - The path to the directory that is being checked for existence.
# Returns:
#  0 if the directory exists.
#  4 if the directory does not exist
# Outputs:
#  FOUND if the directory exists.
#######################################
assert_dir_exists() {
  local dir=$1
  if [ -d "$dir" ]; then
    echo "FOUND"
  else
    echo "The directory:$dir does not exist."
    exit 4
  fi
}

#######################################
# Checks if file/filepath exists, and returns FOUND/NOTFOUND accordingly.
# Local variables:
# filepath
# Globals:
#  None.
# Arguments:
#  filepath - The path to the file that is being checked for existence.
# Returns:
#  0 if the function is executed successfully.
# Outputs:
#  FOUND if the file exists.
#  NOTFOUND if the file does not exist.
#######################################
assert_file_exists() {
  local filepath=$1
  if [ -f "$filepath" ]; then
    echo "FOUND"
  else
    echo "The file:$filepath does not exist."
    exit 4
  fi
}

#######################################
# Checks if the current path is the root directory of this project, throws
# error if it does not exist.
# Local variables:
# output_path
# output_path_length
# current_path
# last_characters_of_current_path
# Globals:
#  None.
# Arguments:
#  output_path - The path of the latex compilation output directory.
# Returns:
#  0 if the directory exists.
#  5 if the directory does not exist
# Outputs:
#  FOUND if the directory exists.
#######################################
assert_current_directory_is_output_dir() {
  local output_path="$1"
  local output_path_length=${#output_path}

  local current_path=$PWD
  local last_characters_of_current_path=${current_path:(-$output_path_length)}
  if [[ "$last_characters_of_current_path" == "$output_path" ]]; then
    echo "FOUND"
  else
    echo "ERROR, the last characters of current path:$last_characters_of_current_path is not equal to the output path:$output_path"
    exit 5
  fi
}

#######################################
# Checks if the current path is the root directory of this project, returns
# FOUND/NOTFOUND accordingly. This check is performed by checking if the
# report.tex file is found at the relative position it would be in, as seen
# from the root directory.
# Local variables:
# path_to_report_tex_file
# Globals:
#  None.
# Arguments:
#  path_to_report_tex_file - The path to the report.tex as seen from root dir.
# Returns:
#  0 if the function is evaluated successfully.
# Outputs:
#  FOUND if the report.tex exists at the expected relative position.
#  NOTFOUND if the report.tex exists at the expected relative position.
#######################################
is_root_dir() {
  local path_to_report_tex_file="$1"
  read -p "path_to_report_tex_file=$PWD/$path_to_report_tex_file"
  if [ -f "$PWD/$path_to_report_tex_file" ]; then
    echo "FOUND"
  else
    echo "NOTFOUND"
  fi
}

#######################################
# Checks if the current path is the root directory of this project. This check
# is performed by checking if the report.tex file is found at the relative
# position it would be in, as seen from the root directory. Throws error if the
# file is not found at the expected relative position.
# Local variables:
# path_to_report_tex_file
# Globals:
#  None.
# Arguments:
#  path_to_report_tex_file - The path to the report.tex as seen from root dir.
# Returns:
#  0 if the report.tex exists at the expected relative position.
#  6 if the report.tex exists at the expected relative position.
# Outputs:
#  FOUND if the report.tex exists at the expected relative position.
#######################################
assert_is_root_dir() {
  local path_to_report_tex_file="$1"
  if [ -f "$path_to_report_tex_file" ]; then
    echo "FOUND"
  else
    echo "ERROR, the current path:$PWD is not the root directory."
    exit 6
  fi
}

copy_stylefiles_to_root_dir() {

  for file_path in "$REL_PATH_CONTAINING_MAIN_TEX/"*; do
    if [ -f "$file_path" ]; then
      file_name=$(basename -- "$file_path")
      if [[ "$file_name" != "$REPORT_FILENAME.*" ]]; then
        cp "$PWD/$file_path" "$PWD/$file_name"
        assert_file_exists "$PWD/$file_name"
      fi
    fi
  done
}

remove_stylefiles_to_root_dir() {
  for file_path in "$REL_PATH_CONTAINING_MAIN_TEX/"*; do
    if [ -f "$file_path" ]; then
      if [[ "$file_name" != "$REPORT_FILENAME.*" ]]; then
        file_name=$(basename -- "$file_path")
        rm -f "$PWD/$file_name"
      fi
    fi
  done
}