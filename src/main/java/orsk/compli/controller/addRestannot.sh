#!/bin/bash

# Function to ensure the correct @RestController annotation in Java files
replace_rest_controller() {
    local dir=$1
    local prefix=$2
    echo "Processing directory: $dir with prefix: $prefix"

    # Iterate over all Java files in the specified directory
    find "$dir" -type f -name "*.java" | while read -r file; do
        class_name=$(basename "$file" .java) # Extract class name
        annotation="@RestController(\"$prefix$class_name\")"

        # Check if @RestController already exists
        if grep -q "@RestController" "$file"; then
            # Replace existing @RestController annotation with the correct one
            sed -i.bak "s|@RestController.*|$annotation|g" "$file" && rm "$file.bak"
            echo "Replaced @RestController in $file"
        else
            # Add the annotation before the first class declaration if it doesn't exist
            sed -i.bak "/public class/i $annotation" "$file" && rm "$file.bak"
            echo "Added @RestController to $file"
        fi
    done
}

# Directories and prefixes
jpa_dir="/Users/simonbeckmann/IdeaProjects/compliMySQL/src/main/java/orsk/compli/controller/jpa"
mongo_dir="/Users/simonbeckmann/IdeaProjects/compliMySQL/src/main/java/orsk/compli/controller/mongo"
neo4j_dir="/Users/simonbeckmann/IdeaProjects/compliMySQL/src/main/java/orsk/compli/controller/neo4j"

# Ensure the script is run from a Mac-compatible environment
if [[ "$(uname)" != "Darwin" ]]; then
    echo "This script is designed for macOS. Exiting."
    exit 1
fi

# Process each directory
replace_rest_controller "$jpa_dir" "jpa"
replace_rest_controller "$mongo_dir" "mongo"
replace_rest_controller "$neo4j_dir" "neo4j"

echo "Annotation replacement process completed."