#!/bin/bash

input="input.py"
output="output.html"

echo "<html><body><pre style=\"font-family: monospace\">" > "$output"

while IFS= read -r line; do
    # Primero escapamos los caracteres HTML especiales
    line=$(echo "$line" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g')

    # Luego resaltamos operadores (incluyendo &lt; y &gt;)
    line=$(echo "$line" | sed -E 's/(&lt;=|&gt;=|==|!=|=|\+=|-=|\*=|\/=|\*\*=|\/\/|%|\+|-|\*|\/|&amp;|\||\^|~|&lt;|&gt;|&lt;&lt;|&gt;&gt;)/<span style="color:red">\1<\/span>/g')
    
    highlighted=$(echo "$line" | sed -E 's/\b(and|or|not|in|is)\b/<span style="color:red">\1<\/span>/g')

    echo "$line" >> "$output"
done < "$input"

echo "</pre></body></html>" >> "$output"