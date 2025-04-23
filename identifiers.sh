#!/bin/bash

input="input.py"
output="output.html"

echo "<html><body><pre>" > "$output"

#pattern to identify variables and functions
# [a-zA-Z_] - check if it starts with letter (lowercase or capital) or underscore
# [a-zA-Z0-9_]* - check if it is followed by any combination of letters, numbers or underscores
# (=|\(|\s) - check if it is followed by equals, parenthesis, or whitespace

variable_pattern='([a-zA-Z_][a-zA-Z0-9_]*)[[:space:]]*='
function_pattern='(def[[:space:]]+)([a-zA-Z_][a-zA-Z0-9_]*)[[:space:]]*\('

while IFS= read -r line; do
    #identifiers

    #functions first, prevents double highlighting
    #highlighted=$(echo "$line" | sed -E 's/'"$function_pattern"'\1/<span style="color:red">\2<\/span>(/g')
    highlighted=$(echo "$line" | sed -E 's/(def[[:space:]]+)([a-zA-Z_][a-zA-Z0-9_]*)/\1<span style="color:red">\2<\/span>/g')

    #variables
    highlighted=$(echo "$highlighted" | sed -E 's/'"$variable_pattern"'/<span style="color:red">\1<\/span>=/g')

    echo "$highlighted" >> "$output"
done < "$input"

echo "</pre></body></html>" >> "$output"

# --- NOTES ---
# '>' overwrites output.html with '<html><body><pre>'
# '<pre>' preserves whitespace (so Python indentation isn't modified)
# 'while IFS= read -r line ...' loops through each line of input.py
# 'IFS=' prevents trimming leading/trailing spaces
# '-r' prevents backslash (\) interpretation
# each line from input.py is stored in "$line"
# echo "$line" -> passes the current line to sed (stream editor)
# sed -E 's/.../g' -> replaces all matches with a color <span>
# \b -> word boundary (ensures whole-word matching)
# g -> global (replace all occurrences in the line)
# echo "$highlighted" >> "$output" -> appends the modified line to output.html
# '</pre></body></html>' are closing tags

#   =       # Literal equal sign
#   |       # OR
#   \(      # Literal opening parenthesis (escaped with backslash)
#   |       # OR
#   \s      # Any whitespace character (space, tab, newline)