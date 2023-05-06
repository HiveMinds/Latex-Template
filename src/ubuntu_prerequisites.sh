#!/bin/bash

# Detect os.
os_is_supported() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "FOUND"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    echo "NOTFOUND"
  elif [[ "$OSTYPE" == "cygwin" ]]; then
    # POSIX compatibility layer and Linux environment emulation for Windows
    echo "NOTFOUND"
  elif [[ "$OSTYPE" == "msys" ]]; then
    # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    echo "NOTFOUND"
  elif [[ "$OSTYPE" == "freebsd"* ]]; then
    echo "NOTFOUND"
  else
    echo "NOTFOUND"
  fi
}

assert_os_is_supported() {
  if [[ "$(os_is_supported)" != "FOUND" ]]; then
    echo "Error, os:$OSTYPE is not (yet) supported, please help build support."
    exit 5
  fi
}

install_prerequisites() {
  local document_type="$1"
  assert_os_is_supported
  ensure_apt_pkg "texlive-lang-european"

  if [[ "$document_type" == "TUDelft_thesis" ]]; then
    # Install the roboto font used by the TU Delft style files.
    ensure_apt_pkg "fonts-roboto"
    ensure_apt_pkg "texlive-fonts-extra"
  fi
}

assert_initial_path() {
  ## Ensure the script is executed from the root directory.
  if [ "$(is_root_dir "$REL_MAIN_TEX_FILEPATH")" == "FOUND" ]; then
    echo "FOUND"
  else
    # Get length of expected subdir
    expected_path_length=${#REL_PATH_CONTAINING_MAIN_TEX}
    echo "REL_PATH_CONTAINING_MAIN_TEX=$REL_PATH_CONTAINING_MAIN_TEX"
    if [[ "${PWD: -$expected_path_length}" == "$REL_PATH_CONTAINING_MAIN_TEX" ]]; then
      cd ../..
      if [ "$(is_root_dir $REL_MAIN_TEX_FILEPATH)" == "FOUND" ]; then
        echo "FOUND"
      else
        echo "The script should be able to go up into the root directory with two parents, but it did not."
        exit 20
      fi
    else
      echo "You are calling this script from the wrong directory."
      echo "PWD=$PWD"
      echo "Expected path towards main.tex is:$REL_MAIN_TEX_FILEPATH"
      exit 21
    fi
  fi
}
