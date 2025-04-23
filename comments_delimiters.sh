#!/bin/bash

input="input.py"
output="comments.html"

echo "<html><body><pre>" > "$output"

while IFS= read -r line; do
    lol=$(echo "$line" | sed -E 's/(#.*)/<span style="color:green">\1<\/span>/g')

    highlighted=$(echo "$lol" | sed -E 's/([\(\)\{\}\[])/<span style="color:blue">\1<\/span>/g')    

    echo "$highlighted" >> "$output"
done < "$input"

sed -i -z -E 's/("""[^"]*""")/<span style="color:green">\1<\/span>/g' "$output"
sed -i -z -E "s/('''[^']*''')/<span style="color:green">\1<\/span>/g" "$output"

echo "</pre></body></html>" >> "$output"