#!/bin/bash

# Function to install the files listed in ez.list

install() {

    local ez_list=("gscs.sh" "ezgsutil.sh")  # Replace with your actual files in ez.list

    for file in "${ez_list[@]}"; do

        regc "./$file.sh" "ez $file" "$file"

    done

}

# Helper function to register a command with its corresponding syntax

regc() {

    local syntax=$1

    local command_name=$2

    local aliases=("${@:3}")

    # Assign the syntax to the command name and aliases

    command_mappings["$command_name"]="$syntax"

    for alias in "${aliases[@]}"; do

        command_mappings["$alias"]="$syntax"

    done

}

# Function to check if ez.list exists and return the list of files

# Function to check if ez.list exists and return the list of files

check_ez_list() {

    local ez_list_file="ez.list"

    if [[ -f $ez_list_file ]]; then

        echo "ez.list already exists"

        echo "Contents:"

        cat "$ez_list_file"

    else

        install

    fi

}

# Main menu function

main_menu() {

    echo "Main menu"

    PS3="Select an option: "

    options=("View ez.list" "Install" "Quit")

    select opt in "${options[@]}"; do

        case $opt in

            "View ez.list")

                echo "Contents of ez.list:"

                for file in "${ez_list[@]}"; do

                    echo "$file"

                done

                ;;

            "Install")

                install

                ;;

            "Quit")

                echo "Exiting..."

                break

                ;;

            *)

                echo "Invalid option: $REPLY"

                ;;

        esac

    done

}

# Declare an associative array to hold the command mappings

declare -A command_mappings

# Check if ez.list exists and return the list of files

check_ez_list

# Function to execute a registered command

execute_command() {

    local command_name=$1

    local command_arguments=("${command_mappings[$command_name]}")

    if [[ $command_name == "ez" || $command_name == "ez " ]]; then

        main_menu

    elif [[ -n $command_arguments ]]; then

        echo "Running $command_name with arguments: ${command_arguments[@]}"

    else

        echo "Command not found: $command_name"

    fi

}

# Example usage

execute_command "$1"

