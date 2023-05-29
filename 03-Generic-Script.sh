#!/bin/bash

# Carpeta de archivos
folder="2016-01-01"

# Ruta completa del directorio actual
current_dir=$(pwd)

# Ruta completa de la carpeta de archivos
folder_dir="${current_dir}/${folder}"

# Verificar si la carpeta de archivos existe
if [ ! -d "$folder_dir" ]; then
  echo "La carpeta de archivos no existe: $folder_dir"
  exit 1
fi

# Verificar si se proporcionó la fecha y la ruta de exiftool como argumentos
if [ $# -lt 2 ]; then
  echo "Debe proporcionar la fecha y la ruta de exiftool como argumentos."
  echo "Ejemplo de uso: bash apply_date.sh 2023-05-28 /ruta/a/exiftool"
  exit 1
fi

# Fecha a aplicar
date_to_apply="$1"

# Ruta de exiftool
exiftool_path="$2"

# Verificar si la ruta de exiftool es válida
if [ ! -x "$exiftool_path" ]; then
  echo "La ruta de exiftool no es válida o no se puede ejecutar: $exiftool_path"
  exit 1
fi

# Recorrer todos los archivos en la carpeta
for file in "$folder_dir"/*; do
  # Obtener la extensión del archivo
  extension="${file##*.}"

  # Aplicar la fecha al metadato correspondiente utilizando exiftool
  if [ "$extension" == "jpg" ]; then
    echo | "$exiftool_path" -overwrite_original -DateTimeOriginal="$date_to_apply" "$file"
  elif [ "$extension" == "png" ]; then
    echo | "$exiftool_path" -overwrite_original -CreationTime="$date_to_apply" "$file"
  else
    echo "Formato de archivo no compatible: $file"
  fi

  echo "Se ha aplicado la fecha al archivo: $file"
done

echo "Proceso completado."
