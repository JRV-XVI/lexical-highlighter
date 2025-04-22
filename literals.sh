#!/bin/bash
# literals.sh - Resalta literals de Python con color #a5ff90 en HTML

input_file=${1:-"output_temp.html"}
output_file=${2:-"output.html"}

# Lee el contenido procesado por keywords.sh
content=$(cat "$input_file")

# Resalta string literals (comillas simples)
content=$(echo "$content" | sed -E "s/'([^']*)'/<span style=\"color:#a5ff90\">'\\1'<\/span>/g")

# Resalta string literals (comillas dobles)
content=$(echo "$content" | sed -E "s/\"([^\"]*)\"/<span style=\"color:#a5ff90\">\"\\1\"<\/span>/g")

# Resalta f-strings (simplificado)
content=$(echo "$content" | sed -E "s/f\"([^\"]*)\"/<span style=\"color:#a5ff90\">f\"\\1\"<\/span>/g")
content=$(echo "$content" | sed -E "s/f'([^']*)'/<span style=\"color:#a5ff90\">f'\\1'<\/span>/g")

# Resalta números (integers, floats, complex)
content=$(echo "$content" | sed -E "s/\b([0-9]+([.][0-9]*)?([eE][+-]?[0-9]+)?j?)(\b|$)/<span style=\"color:#a5ff90\">\\1<\/span>/g")

# Genera el archivo HTML final
cat > "$output_file" << EOF
<html><body><pre>
$content
</pre></body></html>
EOF

# Limpia el archivo temporal
rm -f "$input_file"

echo "Archivo HTML generado: $output_file"