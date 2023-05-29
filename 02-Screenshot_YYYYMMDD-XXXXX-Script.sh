#!/bin/bash

# Carpeta de imágenes
image_folder="Screenshot_YYYYMMDD-XXXXXX"

# Ruta completa del directorio actual
current_dir=$(pwd)

# Ruta completa de la carpeta de imágenes
image_dir="${current_dir}/${image_folder}"

# Verificar si la carpeta de imágenes existe
if [ ! -d "$image_dir" ]; then
  echo "La carpeta de imágenes no existe: $image_dir"
  exit 1
fi

# Verificar si se proporcionó la ruta de exiftool como argumento
if [ $# -eq 0 ]; then
  echo "Debe proporcionar la ruta de exiftool como argumento."
  echo "Ejemplo de uso: bash extract_date.sh /ruta/a/exiftool"
  exit 1
fi

# Ruta de exiftool
exiftool_path=$1

# Verificar si la ruta de exiftool es válida
if [ ! -x "$exiftool_path" ]; then
  echo "La ruta de exiftool no es válida o no se puede ejecutar: $exiftool_path"
  exit 1
fi

# Recorrer todas las imágenes en la carpeta
for image_file in "$image_dir"/*.png; do
  # Obtener el nombre del archivo sin extensión
  filename=$(basename -- "$image_file")
  filename_without_extension="${filename%.*}"

  # Extraer la fecha del nombre del archivo en el formato "IMG-YYYYMMDD"
  date_taken="${filename_without_extension%-*}"

  # Obtener la fecha en el formato YYYY-MM-DD
  year="${date_taken:11:4}"
  month="${date_taken:15:2}"
  day="${date_taken:17:2}"
  formatted_date="${year}-${month}-${day} 00:00:00"

  # Aplicar la fecha al metadato "DateTimeOriginal" utilizando exiftool
  # echo | "$exiftool_path" -overwrite_original -DateTimeOriginal="$formatted_date" "$image_file"
  ## Para PNG
  echo | "$exiftool_path" -overwrite_original -DateTimeOriginal="$formatted_date" -CreationTime="$formatted_date" "$image_file"

  echo "Se ha actualizado la fecha del archivo: $image_file"
done

echo "Proceso completado."