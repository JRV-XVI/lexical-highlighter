#!/bin/bash

input=${1:-"input.py"}
output=${2:-"output.html"}

echo "<html><body><pre style=\"font-family: monospace; background-color: black; color: white;\">" > "$output"

# Check if input file exists
if [ ! -f "$input" ]; then
    echo "Input file $input not found!"
    exit 1
fi

# Define Python keywords
KEYWORDS="False|None|True|and|as|assert|async|await|break|class|continue|def|del|elif|else|except|finally|for|from|global|if|import|in|is|lambda|nonlocal|not|or|pass|raise|return|try|while|with|yield"

# Identify variables, functions, and classes
vars=$(grep -E '^\s*[a-zA-Z_][a-zA-Z0-9_]*\s*=' "$input" | sed -E 's/^\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*=.*/\1/')
vars+=" "$(grep -Eo 'def [^(]+\(([^)]*)\)' "$input" | sed -E 's/.*\(([^)]*)\)/\1/' | tr ',' '\n' | sed -E 's/\s*([a-zA-Z_][a-zA-Z0-9_]*).*/\1/')
vars+=" "$(grep -Eo 'for [a-zA-Z_][a-zA-Z0-9_]* in' "$input" | sed -E 's/for ([a-zA-Z_][a-zA-Z0-9_]*) in/\1/')
var_list=$(echo "$vars" | tr ' ' '\n' | grep -v -E "^(${KEYWORDS})$" | grep -v '^$' | sort -u)
func_list=$(grep -Eo 'def [a-zA-Z_][a-zA-Z0-9_]*' "$input" | sed 's/def //g' | sort -u)
class_list=$(grep -Eo 'class [a-zA-Z_][a-zA-Z0-9_]*' "$input" | sed 's/class //g' | sort -u)

while IFS= read -r line; do
    # Step 1: First extract and save comments
    if [[ "$line" == *"#"* ]]; then
        comment="${line#*#}"
        code="${line%%#*}"
        has_comment=true
    else
        code="$line"
        has_comment=false
    fi
    
    # Step 2: Process code part
    
    # HTML escape the code
    code=$(echo "$code" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g')
    
    # Step 3: Apply syntax highlighting using placeholders
    # IMPORTANT: Order matters! We process in order from most specific to most general
    
    # 1. Mark strings first (they could contain keywords or other patterns)
    code=$(echo "$code" | sed -E 's/(f?)"([^"\\]*(\\.[^"\\]*)*)"/__STRING__\1"\2"__END_STRING__/g')
    code=$(echo "$code" | sed -E "s/(f?)'([^'\\]*(\\.[^'\\]*)*)'/__STRING__\1'\2'__END_STRING__/g")
    
    # 2. Mark classes before functions (they might be more specific)
    for cls in $class_list; do
        code=$(echo "$code" | sed -E "s/\\b${cls}\\b/__CLASS__${cls}__END_CLASS__/g")
    done
    
    # 3. Mark functions
    for func in $func_list; do
        code=$(echo "$code" | sed -E "s/\\b${func}\\b/__FUNC__${func}__END_FUNC__/g")
    done
    
    # 4. Mark variables
    for var in $var_list; do
        # Skip empty variables that might come from parsing errors
        if [ -n "$var" ]; then
            code=$(echo "$code" | sed -E "s/\\b${var}\\b/__VAR__${var}__END_VAR__/g")
        fi
    done
    
    # 5. Mark keywords after functions and variables to avoid conflicts
    code=$(echo "$code" | sed -E "s/\\b(${KEYWORDS})\\b/__KEYWORD__\1__END_KEYWORD__/g")
    
    # 6. Mark numbers
    code=$(echo "$code" | sed -E 's/\b([0-9]+([.][0-9]*)?([eE][+-]?[0-9]+)?j?)\b/__NUMBER__\1__END_NUMBER__/g')
    
    # 7. Mark operators
    code=$(echo "$code" | sed -E 's/(&lt;=|&gt;=|==|!=|=|\+=|-=|\*=|\/=|\*\*=|\/\/=|%=|\*\*|\/\/|%|\+|-|\*|\/|\&amp;|\||\^|~|&lt;|&gt;|&lt;&lt;|&gt;&gt;)/__OPERATOR__\1__END_OPERATOR__/g')
    
    # 8. Mark delimiters
    code=$(echo "$code" | sed -E 's/([\(\)\[\]\{\}])/__DELIMITER__\1__END_DELIMITER__/g')
    
    # 9. Mark punctuation (lowest priority)
    code=$(echo "$code" | sed -E 's/([,.;:])/__PUNCT__\1__END_PUNCT__/g')
    
    # Step 4: Replace placeholders with HTML spans - Order also matters here!
    # Perform replacements in reverse order to avoid nested placeholder issues
    
    # Replace placeholders in a specific order to handle nested patterns
    # Start with the most specific/inner elements and work outward
    
    # Replace strings first (they might contain other patterns)
    code=$(echo "$code" | sed 's/__STRING__\([^_]*\)__END_STRING__/<span style="color:palegreen">\1<\/span>/g')
    
    # Replace numbers
    code=$(echo "$code" | sed 's/__NUMBER__\([^_]*\)__END_NUMBER__/<span style="color:palegreen">\1<\/span>/g')
    
    # Replace punctuation
    code=$(echo "$code" | sed 's/__PUNCT__\([^_]*\)__END_PUNCT__/<span style="color:#ADD8E6">\1<\/span>/g')
    
    # Replace delimiters
    code=$(echo "$code" | sed 's/__DELIMITER__\([^_]*\)__END_DELIMITER__/<span style="color:blue">\1<\/span>/g')
    
    # Replace operators
    code=$(echo "$code" | sed 's/__OPERATOR__\([^_]*\)__END_OPERATOR__/<span style="color:lightpink">\1<\/span>/g')
    
    # Replace keywords
    code=$(echo "$code" | sed 's/__KEYWORD__\([^_]*\)__END_KEYWORD__/<span style="color:orange">\1<\/span>/g')
    
    # Replace classes, functions, variables (in that order)
    code=$(echo "$code" | sed 's/__CLASS__\([^_]*\)__END_CLASS__/<span style="color:#FF4500">\1<\/span>/g')
    code=$(echo "$code" | sed 's/__FUNC__\([^_]*\)__END_FUNC__/<span style="color:#FF00FF">\1<\/span>/g')
    code=$(echo "$code" | sed 's/__VAR__\([^_]*\)__END_VAR__/<span style="color:#FF6F61">\1<\/span>/g')
    
    # Step 5: Handle comment if exists
    if [ "$has_comment" = true ]; then
        # HTML escape the comment
        comment=$(echo "$comment" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g')
        # Add highlighted comment
        highlighted_line="$code<span style=\"color:#DDA0DD\">#$comment</span>"
    else
        highlighted_line="$code"
    fi
    
    echo "$highlighted_line" >> "$output"
done < "$input"

echo "</pre></body></html>" >> "$output"
echo "HTML file generated: $output"