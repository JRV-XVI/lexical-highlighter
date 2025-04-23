#!/bin/bash

input=${1:-"input.py"}
output=${2:-"output.html"}

# Lista de keywords de Python como un patrón regex
KEYWORDS="False|None|True|and|as|assert|async|await|break|class|continue|def|del|elif|else|except|finally|for|from|global|if|import|in|is|lambda|nonlocal|not|or|pass|raise|return|try|while|with|yield"

echo "<html><body><pre style=\"font-family: monospace\">" > "$output"

while IFS= read -r line; do
    # Escapar caracteres HTML
    line=$(echo "$line" | sed -e 's@&@\&amp;@g' -e 's@<@\&lt;@g' -e 's@>@\&gt;@g')

    # Marcar strings (evita reemplazos dentro de ellos)
    line=$(echo "$line" | sed -E 's@(f?)"([^"]*)"@__STR_DQ__\1"\2"__END__@g')
    line=$(echo "$line" | sed -E "s@(f?)'([^']*)'@__STR_SQ__\1'\2'__END__@g")

    # Marcar keywords (fuera de strings)
    line=$(echo "$line" | sed -E "s@\\b(${KEYWORDS})\\b@__KEY__\1__END__@g")

    # Resaltar operadores
    line=$(echo "$line" | sed -E 's@(&lt;=|&gt;=|==|!=|=|\+=|-=|\*=|/=|\*\*=|//|%|\+|-|\*|/|\&amp;|\||\^|~|&lt;|&gt;|&lt;&lt;|&gt;&gt;)@<span style="color:red">\1</span>@g')

    # Resaltar números
    line=$(echo "$line" | sed -E 's@\b([0-9]+([.][0-9]*)?([eE][+-]?[0-9]+)?j?)\b@<span style="color:lightgreen">\1</span>@g')

    # Restaurar keywords como HTML
    line=$(echo "$line" | sed -E 's@__KEY__(.*?)__END__@<span style="color:orange">\1</span>@g')

    # Restaurar strings
    line=$(echo "$line" | sed -E 's@__STR_DQ__(f?)"([^"]*)"__END__@<span style="color:lightgreen">\1"\2"</span>@g')
    line=$(echo "$line" | sed -E "s@__STR_SQ__(f?)'([^']*)'__END__@<span style=\"color:lightgreen\">\1'\2'</span>@g")

    echo "$line" >> "$output"
done < "$input"

echo "</pre></body></html>" >> "$output"
echo "Archivo HTML generado: $output"
