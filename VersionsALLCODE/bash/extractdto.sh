#!/bin/bash

# Script to aggregate all Java code files into a single output file with detailed logging and error handling
# Author: [Your Name]
# Version: 2.0
# Last Updated: [Date]

# Constants
SEARCH_DIR="/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/src/main/java/orsk/compli/service/jpa/"
OUTPUT_FILE="/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/VersionsALLCODE/code/VERSION18thdecmeberMAIN_APPLICATION_CODE_ALL_java_code.txt"
LOG_FILE="/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/VersionsALLCODE/log/script_execution.log"

# Initialize or clear output and log files
> "$OUTPUT_FILE"
> "$LOG_FILE"

# Function to log messages
log_message() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

# Function to validate the existence of a directory
validate_directory() {
    if [[ ! -d "$1" ]]; then
        log_message "ERROR: Directory $1 does not exist."
        echo "ERROR: Directory $1 does not exist." >&2
        exit 1
    fi
}

# Function to validate or create a file
validate_file() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        touch "$file" || { echo "ERROR: Unable to create file $file." >&2; exit 1; }
    fi
}

# Function to process Java files
process_java_files() {
    local dir="$1"
    local output="$2"
    local file_count=0

    find "$dir" -type f -name "*.java" | while read -r file; do
        if [[ -f "$file" ]]; then
            ((file_count++))
            echo "==============================" >> "$output"
            echo "File: $file" >> "$output"
            echo "==============================" >> "$output"
            cat "$file" >> "$output"
            echo -e "\n\n" >> "$output"
            log_message "Processed file: $file"
        else
            log_message "WARNING: Skipped non-regular file: $file"
        fi
    done

    log_message "Total Java files processed: $file_count"
}

# Main Execution
log_message "Script execution started."

# Validate the input directory
validate_directory "$SEARCH_DIR"

# Validate or create the output file
validate_file "$OUTPUT_FILE"

# Process Java files and log progress
process_java_files "$SEARCH_DIR" "$OUTPUT_FILE"

# Notify completion
log_message "Script execution completed successfully. Output saved to $OUTPUT_FILE."
echo "All Java class code has been saved to $OUTPUT_FILE"