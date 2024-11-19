#!/bin/bash

# Define the directory to search and the output file
SEARCH_DIR="/Users/simonbeckmann/IdeaProjects/compliMySQL/src/main/java/orsk/compli/dtos"
OUTPUT_FILE="/Users/simonbeckmann/IdeaProjects/compliMySQL/dtosall_java_code.txt"

# Clear or create the output file
> "$OUTPUT_FILE"

# Find all Java files and append their content to the output file
find "$SEARCH_DIR" -type f -name "*.java" | while read -r file; do
    # Add a header for each file
    echo "==============================" >> "$OUTPUT_FILE"
    echo "File: $file" >> "$OUTPUT_FILE"
    echo "==============================" >> "$OUTPUT_FILE"

    # Append the content of each Java file
    cat "$file" >> "$OUTPUT_FILE"
    echo -e "\n\n" >> "$OUTPUT_FILE"  # Add space between files
done

# Notify the user of completion
echo "All Java class code has been saved to $OUTPUT_FILE"