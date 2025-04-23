#!/bin/bash
# keywords.sh - Resalta keywords de Python con color #ff9d00 en HTML

# Lista de keywords de Python
KEYWORDS=(
    "False" "None" "True" "and" "as" "assert" "async" "await" "break" "class" "continue"
    "def" "del" "elif" "else" "except" "finally" "for" "from" "global" "if" "import"
    "in" "is" "lambda" "nonlocal" "not" "or" "pass" "raise" "return" "try" "while"
    "with" "yield"
)

# Lee el contenido del archivo Python
input_file=${1:-"input.py"}
output_file=${2:-"output_temp.html"}
content=$(cat "$input_file")

# Convierte el contenido a un formato HTML seguro (escapa < y >)
content=$(echo "$content" | sed 's/</\&lt;/g' | sed 's/>/\&gt;/g')

# Resalta cada keyword
for keyword in "${KEYWORDS[@]}"; do
    # Usa límites de palabra para coincidir solo con palabras completas
    content=$(echo "$content" | sed "s/\b${keyword}\b/<span style=\"color:#ff9d00\">&<\/span>/g")
done

# Guarda el contenido procesado en un archivo temporal
echo "$content" > "$output_file"
