# Lexical Highlighter

## Descripción del Proyecto

Este proyecto, **Lexical Highlighter**, es una herramienta diseñada para analizar código fuente escrito en Python y generar un archivo HTML con resaltado de sintaxis. El resaltado se realiza categorizando elementos léxicos del código, como palabras clave, identificadores, literales, operadores, delimitadores, comentarios y puntuación, y aplicando diferentes colores para mejorar la legibilidad y comprensión del código.

El programa está implementado en **Bash**, utilizando expresiones regulares para identificar y resaltar las diferentes categorías léxicas. El resultado es un archivo HTML con un fondo negro y colores personalizados para cada categoría.

## Categorías Léxicas

El programa identifica y resalta las siguientes categorías léxicas del lenguaje Python:

### 1. **Palabras Clave (Keywords)**
- Ejemplos: `False`, `None`, `True`, `and`, `as`, `assert`, `break`, `class`, `continue`, `def`, etc.

### 2. **Identificadores**
- Ejemplos: `my_variable`, `_privateVar`, `ClassName`, `function_name`.

### 3. **Literales**
- **String Literals**: `'hello'`, `"world"`, `'''multiline'''`, `f"formatted {value}"`.
- **Numeric Literals**: `123`, `45.67`, `5j`.
- **Boolean Literals**: `True`, `False`.
- **Special Literal**: `None`.

### 4. **Operadores**
- **Aritméticos**: `+`, `-`, `*`, `/`, `%`, `**`, `//`.
- **Comparación**: `==`, `!=`, `<`, `>`, `<=`, `>=`.
- **Lógicos**: `and`, `or`, `not`.
- **Asignación**: `=`, `+=`, `-=`, `*=`, `/=`, `&=`, `|=`, `^=`, `>>=`, `<<=`, `**=`.
- **Bitwise**: `&`, `|`, `^`, `~`, `<<`, `>>`.
- **Membership**: `in`, `not in`.
- **Identity**: `is`, `is not`.

### 5. **Delimitadores**
- Ejemplos: `()`, `[]`, `{}`.

### 6. **Comentarios**
- Ejemplo: `# This is a single-line comment`.

### 7. **Puntuación**
- Ejemplos: `.`, `,`, `:`.

---

## Expresiones Regulares

El programa utiliza expresiones regulares en Bash para identificar las categorías léxicas. Estas expresiones permiten buscar patrones específicos en el código fuente y aplicar estilos HTML para resaltarlos.

---

## Instrucciones para Ejecutar el Programa

1. **Preparar el Entorno**  
   Asegúrate de tener Bash instalado en tu sistema. Este programa está diseñado para ejecutarse en sistemas Linux.

2. **Archivos Necesarios**  
   - `main.sh`: Script Bash que realiza el análisis léxico y genera el archivo HTML.
   - `input.py`: Archivo de entrada que contiene el código Python a analizar.

3. **Ejecutar el Programa**  
   Abre una terminal y navega al directorio donde se encuentran los archivos. Ejecuta el siguiente comando:

   ```bash
   bash main.sh input.py output.html