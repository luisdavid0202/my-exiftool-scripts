#!/bin/bash

# Carpeta de videos
folder="videos"

# Ruta completa del directorio actual
current_dir=$(pwd)

# Ruta completa de la carpeta de videos
folder_dir="${current_dir}/${folder}"

# Verificar si la carpeta de videos existe
if [ ! -d "$folder_dir" ]; then
  echo "La carpeta de videos no existe: $folder_dir"
  exit 1
fi

# Recorrer todos los videos en la carpeta
for file in "$folder_dir"/*; do
  # Verificar si el archivo es un video MP4
  if [[ "$file" == *.mp4 ]]; then
    # Obtener el nombre del archivo sin la ruta y la extensión
    filename=$(basename -- "$file")
    filename_without_extension="${filename%.*}"

    # Obtener la fecha del nombre del archivo
    date_from_filename=$(echo "$filename_without_extension" | awk -F"-" '{print $2}')

    # Verificar si la fecha del nombre del archivo es válida (formato: YYYYMMDD)
    if [[ $date_from_filename =~ ^[0-9]{8}$ ]]; then
      # Obtener los componentes de la fecha
      year="${date_from_filename:0:4}"
      month="${date_from_filename:4:2}"
      day="${date_from_filename:6:2}"

      # Cambiar la fecha de modificación y acceso del archivo utilizando touch
      touch -t "${year}${month}${day}0000" "$file"
      formatted_date="${year}-${month}-${day} 00:00:00"
      ffmpeg -i "$file" -metadata creation_time="$formatted_date" -codec copy "${folder_dir}/${filename_without_extension}_modified.mp4"

      echo "Se ha cambiado la fecha de captura del video: $file"
    else
      echo "El nombre del archivo no contiene una fecha válida: $file"
    fi
  fi
done

echo "Proceso completado."
