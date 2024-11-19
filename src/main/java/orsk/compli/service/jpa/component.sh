#!/bin/bash

# Directory containing Java files
TARGET_DIR="/Users/simonbeckmann/IdeaProjects/compliMySQL/src/main/java/orsk/compli/service/jpa"

# Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo "Directory $TARGET_DIR does not exist."
  exit 1
fi

# Process each Java file in the target directory
find "$TARGET_DIR" -type f -name "*.java" | while read -r file; do
  echo "Processing file: $file"

  # Extract the class name
  class_name=$(grep -oE 'public\s+(abstract\s+|final\s+)?class\s+\w+' "$file" | awk '{print $NF}')

  if [[ -z "$class_name" ]]; then
    echo "No class definition found in file: $file"
    continue
  fi
  echo "Detected class name: $class_name"

  # Remove any existing @Service annotations
  sed -i.bak '/@Service/d' "$file"

  # Prepare the new @Service annotation
  service_annotation="@Service(\"jpa${class_name}\")"

  # Check if the new @Service annotation is already present
  if grep -q "$service_annotation" "$file"; then
    echo "Annotation already exists in file: $file"
    continue
  fi

  # Insert the new annotation before the class declaration
  sed -i.bak "/public\s\+.*class\s\+$class_name/i\\
$service_annotation
" "$file"

  # Notify user of changes
  echo "Added @Service annotation to $file"
done

echo "Script execution completed."