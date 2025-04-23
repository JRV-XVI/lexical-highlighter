#!/bin/bash

input="input.py"
output="output.html"

echo "<html><body><pre>" > "$output"

while IFS= read -r line; do
    #punctuation
    highlighted=$(echo "$line" | sed -E 's/([,.:])/<span style="color:cyan">\1<\/span>/g')

    echo "$highlighted" >> "$output"
done < "$input"

echo "</pre></body></html>" >> "$output"