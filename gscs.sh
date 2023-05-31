cheat_sheet_file= {

  "commands": {

    "ls": "Lists the contents of a directory.",

    "cd": "Changes the current directory.",

    "mkdir": "Creates a new directory.",

    "rm": "Deletes a file.",

    "mv": "Moves a file to a new location.",

    "cp": "Copies a file to a new location.",

    "git clone": "Clones a git repository into a directory.",

    "gcloud": "Runs a Google Cloud command.",

    "bash": "Runs a bash command.",

    "python": "Runs a Python script.",

  },

  "legend": {

    "-r": "Recursive. This tells the command to delete all of the files and folders in the specified directory, including any subdirectories.",

    "/": "The root directory. This is the top-level directory of a filesystem.",

    "path/to/folder": "The path to a specific folder. This can be relative or absolute.",

    "folder.path": "The path to a folder, as stored in a Python object.",

    "folder.name": "The name of a folder, as stored in a Python object.",

  },

  "basics": {

    "Bash": "A shell, which is a command-line interpreter. It is used to run commands on a Linux or Unix system.",

    "Python": "A general-purpose programming language. It is used for a variety of tasks, including web development, data science, and machine learning.",

    "Git": "A version control system. It is used to track changes to code and other files.",

  },

  "help_and_man": {

    "help": "The help command provides basic information about a command.",

    "man": "The man command provides more detailed information about a command.",

    "expected_structure": {

      "help": "The help command expects a single argument, which is the name of the command you want help with.",

      "man": "The man command expects two arguments, which are the section number and the name of the command you want help with. The section number is a way of organizing man pages into different categories.",

    },

    "what_it_can_and_cant_do": {

      "help": "The help command can provide information about most commands, but it is not always comprehensive.",

      "man": "The man command can provide very detailed information about most commands, but it can be difficult to read.",

    },

  }

cheat_sheet=$(cat "$cheat_sheet_file")

# Function to display the cheat sheet

display_cheat_sheet() {

    if [[ $# -eq 0 ]]; then

        echo "Usage: gscs [category] [command]"

        echo "Available categories: commands, legend, basics, help_and_man"

        return

    fi

    category="$1"

    if [[ ! $(jq -e ".$category" <<< "$cheat_sheet") ]]; then

        echo "Category '$category' not found in the cheat sheet."

        return

    fi

    if [[ $# -eq 1 ]]; then

        # Display all commands in the category

        echo "Available commands in the '$category' category:"

        jq -r ".$category | to_entries[] | \"- \(.key): \(.value)\"" <<< "$cheat_sheet"

    else

        command="$2"

        description=$(jq -r ".$category.\"$command\"" <<< "$cheat_sheet")

        if [[ "$description" != "null" ]]; then

            echo "$command: $description"

        else

            echo "Command '$command' not found in the '$category' category."

        fi

    fi

}

# Function to display categories and suggestions

display_categories() {

    echo "Available categories:"

    jq -r 'keys[]' <<< "$cheat_sheet"

    echo ""

    echo "For detailed help, use:"

    echo "gscs help"

    echo "gscs man"

}

# Function to display syntax use

display_syntax() {

    echo "Syntax: gscs [category] [command]"

}

# Function to display common errors and tips

display_tips() {

    echo "Common Errors and Tips:"

    echo "- Remember to use proper quoting and escaping when working with Bash."

    echo "- In Python, make sure to indent your code correctly."

    echo "- JavaScript is case-sensitive, so ensure proper capitalization."

    echo "- When encountering an error, check for typos and missing parentheses, brackets, or semicolons."

    echo "- Don't forget to use the appropriate data types and conversions in your code."

}

# Parse command-line arguments

args=("$@")

if [[ $# -eq 0 ]] || [[ "${args[0]}" == "help" ]]; then

    echo "Programming Cheat Sheet (gscs)"

    display_syntax

    echo ""

    echo "Categories and possible redirects:"

    display_categories

    echo ""

    display_tips

elif [[ "${args[0]}" == "man" ]]; then

    echo "The 'man' command provides more detailed information about a command."

    echo "Syntax: gscs man [category] [command]"

    echo "Example: gscs man commands ls"

elif [[ "${args[0]}" == "commands" ]] || [[ "${args[0]}" == "legend" ]] || [[ "${args[0]}" == "basics" ]] || [[ "${args[0]}" == "help_and_man" ]]; then

    display_cheat_sheet "${args[@]}"

else

    echo "Invalid command or category."

    display_syntax

    echo ""

    echo "Categories and possible redirects:"

    display_categories

fi

