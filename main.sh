#!/bin/bash

input=${1:-"input.py"}
output=${2:-"output.html"}

echo "<html><body><pre style=\"font-family: monospace\">" > "$output"

#automatic identification of variable names
vars=$(grep -E '^\s*[a-zA-Z_][a-zA-Z0-9_]*\s*=' "$input" | \
       sed -E 's/^\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*=.*/\1/')

#function parameters
vars+=" "$(grep -Eo 'def [^(]+\(([^)]*)\)' "$input" | \
         sed -E 's/.*\(([^)]*)\)/\1/' | tr ',' '\n' | \
         sed -E 's/\s*([a-zA-Z_][a-zA-Z0-9_]*).*/\1/')

#loop variables
vars+=" "$(grep -Eo 'for [a-zA-Z_][a-zA-Z0-9_]* in' "$input" | \
         sed -E 's/for ([a-zA-Z_][a-zA-Z0-9_]*) in/\1/')

#empty lines and Python keywords to be removed from the list
keywords="False None True and as assert async await break class continue def del elif else except finally for from global if import in is lambda nonlocal not or pass raise return try while with yield"

#variables list
var_list=$(echo "$vars" | tr ' ' '\n' | grep -v -w -e "$keywords" | grep -v '^$' | sort -u)

#function names
func_list=$(grep -Eo 'def [a-zA-Z_][a-zA-Z0-9_]*' "$input" | sed 's/def //g' | sort -u)

#class names
class_list=$(grep -Eo 'class [a-zA-Z_][a-zA-Z0-9_]*' "$input" | sed 's/class //g' | sort -u)

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

    # 5. Resaltar delimiters
    line=$(echo "$line" | sed -E 's/([\(\)\{\}\[])/<span style="color:#87CEFA">\1<\/span>/g')    

    # 6. Resaltar comentarios de una sola linea #
    line=$(echo "$line" | sed -E 's/(#.*)/<span style="color:#DDA0DD">\1<\/span>/g')

    # 7. Variables
    for var in $var_list; do
        line=$(echo "$line" | sed -E "s/\b$var\b/<span style=\"color:red\">$var<\/span>/g")
    done

    # 8. Functions
    for func in $func_list; do
        line=$(echo "$line" | sed -E "s/\b$func\b/<span style=\"color:magenta\">$func<\/span>/g")
    done

    # 9. Classes
    for cls in $class_list; do
        line=$(echo "$line" | sed -E "s/\b$cls\b/<span style=\"color:#FF4500\">$cls<\/span>/g")
    done

    echo "$line" >> "$output"
done < "$input"

echo "</pre></body></html>" >> "$output"
echo "Archivo HTML generado: $output"

