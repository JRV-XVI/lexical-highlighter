#!/bin/bash

input=${1:-"input.py"}
output=${2:-"output.html"}

echo "<html><body><pre style=\"font-family: monospace\">" > "$output"

while IFS= read -r line; do
    # Escapar caracteres HTML
    line=$(echo "$line" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g')

    # 1. Marcar strings (temporales, no HTML aún)
    line=$(echo "$line" | sed -E "s/(f?)\"([^\"]*)\"/__STR__\1\"\2\"__END__/g")
    line=$(echo "$line" | sed -E "s/(f?)'([^']*)'/__STR__\1'\2'__END__/g")

    # 2. Resaltar operadores (solo fuera de los strings)
    line=$(echo "$line" | sed -E 's/(&lt;=|&gt;=|==|!=|=|\+=|-=|\*=|\/=|\*\*=|\/\/|%|\+|-|\*|\/|\&amp;|\||\^|~|&lt;|&gt;|&lt;&lt;|&gt;&gt;)/<span style="color:red">\1<\/span>/g')

    # 3. Resaltar números
    line=$(echo "$line" | sed -E 's/\b([0-9]+([.][0-9]*)?([eE][+-]?[0-9]+)?j?)\b/<span style="color:#a5ff90">\1<\/span>/g')

    # 4. Restaurar strings con HTML
    line=$(echo "$line" | sed -E 's/__STR__(f?)"([^"]*)"__END__/<span style="color:#a5ff90">\1"\2"<\/span>/g')
    line=$(echo "$line" | sed -E "s/__STR__(f?)'([^']*)'__END__/<span style=\"color:#a5ff90\">\1'\2'<\/span>/g")

    echo "$line" >> "$output"
done < "$input"

echo "</pre></body></html>" >> "$output"
echo "Archivo HTML generado: $output"

