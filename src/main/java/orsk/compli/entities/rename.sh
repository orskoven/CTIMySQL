#!/bin/bash

# Prompt the user for the directory and the prefix to prepend
read -p "Enter the directory path (leave empty for current directory): " dir_path
read -p "Enter the prefix to prepend to Java class names and file names: " prefix

# Set the directory to current directory if none provided
dir_path=${dir_path:-.}

# Check if the directory exists
if [ ! -d "$dir_path" ]; then
  echo "Error: Directory '$dir_path' does not exist."
  exit 1
fi

# Change to the target directory
cd "$dir_path" || { echo "Error: Cannot change to directory '$dir_path'."; exit 1; }

# Check if there are any Java files in the directory
shopt -s nullglob
java_files=(*.java)
if [ ${#java_files[@]} -eq 0 ]; then
  echo "No Java files found in the directory '$dir_path'."
  exit 0
fi

# Loop through all Java files in the directory
for file in "${java_files[@]}"; do
  # Extract the public class name from the file
  class_name=$(grep -Po 'public\s+class\s+\K\w+' "$file")

  # If no public class is found, skip the file
  if [ -z "$class_name" ]; then
    echo "No public class found in '$file'. Skipping."
    continue
  fi

  # Create the new class name by prepending the prefix
  new_class_name="${prefix}${class_name}"

  # Create the new filename
  new_file_name="${new_class_name}.java"

  # Check if the new file name already exists to avoid overwriting
  if [ -e "$new_file_name" ]; then
    echo "Error: '$new_file_name' already exists. Skipping renaming of '$file'."
    continue
  fi

  # Update the class name inside the file
  # Use platform-independent sed syntax
  if sed --version >/dev/null 2>&1; then
    # GNU sed
    sed -i "s/\b$class_name\b/$new_class_name/g" "$file"
  else
    # Assume BSD sed (e.g., macOS)
    sed -i '' "s/\b$class_name\b/$new_class_name/g" "$file"
  fi

  # Rename the file
  mv "$file" "$new_file_name"

  echo "Renamed '$file' to '$new_file_name' and updated class name to '$new_class_name'."
done

echo "All Java files have been processed with the prefix '$prefix'."