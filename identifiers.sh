#!/bin/bash

input="input.py"
output="output.html"

echo "<html><body><pre>" > "$output"

#automatic identification of variable names
vars=$(grep -E '^\s*[a-zA-Z_][a-zA-Z0-9_]*\s*=' "$input" | \
       sed -E 's/^\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*=.*/\1/')
# grep -E -> uses extended regex to match lines that look like assignments
# ^\s* -> optional leading spaces
# [a-zA-Z_][a-zA-Z0-9_]* -> a valid variable name (starts with letter or _, followed by alphanumerics or _)
# \s*= -> followed by optional spaces and an equals sign
# sed extracts the variable name using a capture group

#function parameters
vars+=" "$(grep -Eo 'def [^(]+\(([^)]*)\)' "$input" | \
         sed -E 's/.*\(([^)]*)\)/\1/' | tr ',' '\n' | \
         sed -E 's/\s*([a-zA-Z_][a-zA-Z0-9_]*).*/\1/')
# grep -Eo 'def [^(]+\(([^)]*)\)' -> finds function definitions and extracts the parameter list
# tr ',' '\n' -> splits parameters across multiple lines
# final sed -> trims spaces and isolates each parameter name

#loop variables
vars+=" "$(grep -Eo 'for [a-zA-Z_][a-zA-Z0-9_]* in' "$input" | \
         sed -E 's/for ([a-zA-Z_][a-zA-Z0-9_]*) in/\1/')
# matches 'for x in y' loop headers and extracts the loop variable

#empty lines and Python keywords to be removed from the list
keywords="False None True and as assert async await break class continue def del elif else except finally for from global if import in is lambda nonlocal not or pass raise return try while with yield"

#variables list
var_list=$(echo "$vars" | tr ' ' '\n' | grep -v -w -e "$keywords" | grep -v '^$' | sort -u)
# tr ' ' '\n' -> splits all variables into one per line
# grep -v -w -e "$keywords" -> removes keywords
# sort -u -> Removes duplicates and sorts the list

#function names
func_list=$(grep -Eo 'def [a-zA-Z_][a-zA-Z0-9_]*' "$input" | sed 's/def //g' | sort -u)
# matches def function_name
# strips out the def keyword
# sorts and removes duplicates

#class names
class_list=$(grep -Eo 'class [a-zA-Z_][a-zA-Z0-9_]*' "$input" | sed 's/class //g' | sort -u)
# same as with functions, but strips out the class keyword

#highlight variables line by line
while IFS= read -r line; do
    highlighted="$line"

    #variables
    for var in $var_list; do
        highlighted=$(echo "$highlighted" | sed -E "s/\b$var\b/<span style=\"color:red\">$var<\/span>/g")
    done

    #functions
    for func in $func_list; do
        highlighted=$(echo "$highlighted" | sed -E "s/\b$func\b/<span style=\"color:red\">$func<\/span>/g")
    done

    #classes
    for cls in $class_list; do
        highlighted=$(echo "$highlighted" | sed -E "s/\b$cls\b/<span style=\"color:red\">$cls<\/span>/g")
    done

    echo "$highlighted" >> "$output"
done < "$input"

echo "</pre></body></html>" >> "$output"

echo "Identifiers highlighted at: $output"

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