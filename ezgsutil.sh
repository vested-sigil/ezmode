pmes="please enter: "

sfod="source file or dir path"

fodp="file or dir path"

bukn="bucket name"

dpat="dir path"

fpat="file path"

stypes=("URL" "Local dir" "Cloud bucket")

dtypes=("Local dir" "Cloud bucket")

pinp() {

  read -p "$1: " ival

  echo "$ival"

}

argT() {

  local opts=("$@")

  local cnt=${#opts[@]}

  local choice

  local index

  echo "Pls select an option:"

  for ((index=0; index < cnt; index++)); do

    echo "$(($index+1)). ${opts[$index]}"

  done

  while true; do

    read -p "Enter the num of your choice (or 'q' to exit): " choice

    if [ "$choice" = "q" ]; then

      return 1

    fi

    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= cnt )); then

      echo "${opts[$(($choice-1))]}"

      return 0

    else

      echo "Invalid choice. Pls try again."

    fi

  done

}

hcho() {

  local choice=$1

  local inst=$2

  local icas=$3

  local ival

  case $choice in

    $icas)

      ival=$(pinp "$pmes the $inst")

      if [ -z "$ival" ]; then

        echo "$inst is required. Abort."

        return

      fi

      ;;

    *)

      echo "Invalid choice Abort."

      return

      ;;

  esac

  echo "$ival"

}

run_gsutil_cp() {

  local stype=$(hcho "$1" "$sfod" "cp")

  if [ -z "$stype" ]; then

    return

  fi

  local fpath=$(hcho "$2" "$fpat" "cp")

  if [ -z "$fpath" ]; then

    return

  fi

  local dtype=$(hcho "$3" "$dtypes" "cp")

  if [ -z "$dtype" ]; then

    return

  fi

  gsutil cp "$fpath" "$dtype"

}

run_gsutil_mv() {

  local stype=$(hcho "$1" "$sfod" "mv")

  if [ -z "$stype" ]; then

    return

  fi

  local fpath=$(hcho "$2" "$fpat" "mv")

  if [ -z "$fpath" ]; then

    return

  fi

  local dtype=$(hcho "$3" "$dtypes" "mv")

  if [ -z "$dtype" ]; then

    return

  fi

  gsutil mv "$fpath" "$dtype"

}

run_gsutil_rsync() {

  local stype=$(hcho "$1" "$sfod" "rsync")

  if [ -z "$stype" ]; then

    return

  fi

  local fpath=$(hcho "$2" "$fpat" "rsync")

  if [ -z "$fpath" ]; then

    return

  fi

  local dtype=$(hcho "$3" "$dtypes" "rsync")

  if [ -z "$dtype" ]; then

    return

  fi

    gsutil -m rsync -r "$fpath" "$dtype"

}

run_gsutil_cp "$@"

run_gsutil_mv "$@"

run_gsutil_rsync "$@"

