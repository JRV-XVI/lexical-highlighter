#!/bin/bash
# filepath: e:\university\4-semester\computational-methods\project-2\lexical-highlighter\keywords.sh

# Python keywords to highlight
KEYWORDS=(
    "and" "as" "assert" "async" "await"
    "break"
    "class" "continue"
    "def" "del"
    "elif" "else" "except"
    "False" "finally" "for" "from"
    "global"
    "if" "import" "in" "is"
    "lambda"
    "None" "nonlocal" "not"
    "or"
    "pass"
    "raise" "return"
    "True" "try"
    "while" "with"
    "yield"
)

# Orange color code for keywords
KEYWORD_COLOR="\033[38;2;255;157;0m"
RESET_COLOR="\033[0m"

# Function to highlight Python keywords
highlight_keywords() {
    local file="$1"
    local content
    
    # Read the file
    content=$(<"$file")
    
    # Highlight each keyword
    for keyword in "${KEYWORDS[@]}"; do
        # Use regex to match whole words only
        content=$(echo "$content" | sed -E "s/\b($keyword)\b/$KEYWORD_COLOR\1$RESET_COLOR/g")
    done
    
    echo -e "$content"
}

# Check if a file was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <python_file>"
    exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
    echo "Error: File '$1' not found"
    exit 1
fi

# Highlight keywords in the provided file
highlight_keywords "$1"