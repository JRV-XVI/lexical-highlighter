#!/bin/bash

input="input.py"
output="delimiters.html"

echo "<html><body><pre>" > "$output"

while IFS= read -r line; do
    highlighted=$(echo "$line" | sed -E 's/([\(\)\{\}\[])/<span style="color:blue">\1<\/span>/g')    
    echo "$highlighted" >> "$output"
done < "$input"

echo "</pre></body></html>" >> "$output"