#!/bin/bash

input="input.py"
output="output.html"

echo "<html><body><pre>" > "$output"

while IFS= read -r line; do
    # Operators
    highlighted=$(echo "$line" | sed -E 's/\b(\+|\-|\*|\/|%|\*\*|\/\/|==|!=|<|>|\<=|\>=|and|or|not|=|\+=|\-=|\*=|\/=|&=|\|=|\^=|>>=|\*\*=|&|\||\^|~|<<|>>|in|not|is)\b/<span style="color:pink">\1<\/span>/g')


    echo "$highlighted" >> "$output"
done < "$input"

echo "</pre></body></html>" >> "$output"
