#!/bin/bash

input="input.py"
output="output.html"

echo "<html><body><pre>" > "$output"

while IFS= read -r line; do
    #identifiers
    highlighted=$(echo "$line" | sed -E 's/\b(function_name|param1|param2|my_variable|_privateVar|another_var|complex_num|flag|nothing|result|e|ClassName|self|value|compute|i|__str__|logic_operations|a|b|x|y|z|w|m|n|o|p|q|r|s|t)\b/<span style="color:red">\1<\/span>/g')
    # __init__ is a keyword

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