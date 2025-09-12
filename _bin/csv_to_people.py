#!/usr/bin/env python3
"""
Script to read people.csv and generate person records in _people/ directory.
CSV format: Name, Course, Graduation year
Output: _people/firstname_lastname.md files with Jekyll front matter
"""

import csv
import os
import re
from pathlib import Path

def clean_name(name):
    """Clean and format name for filename."""
    # Remove extra spaces and strip
    name = name.strip()
    # Replace spaces with underscores and convert to lowercase
    name = re.sub(r'\s+', '_', name)
    return name.lower()

def generate_person_file(name, course, grad_year, output_dir):
    """Generate a person markdown file."""
    # Clean the name for filename
    filename = clean_name(name) + '.md'
    filepath = output_dir / filename
    
    # Create the content
    content = f"""---
title: {name}
submitted: false
course: {course}
graduated: {grad_year}
---

"""
    
    # Write the file
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"Created: {filepath}")

def main():
    # Set up paths
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    csv_file = project_root / 'people.csv'
    people_dir = project_root / '_people'
    
    # Ensure people directory exists
    people_dir.mkdir(exist_ok=True)
    
    # Check if CSV file exists
    if not csv_file.exists():
        print(f"Error: {csv_file} not found!")
        return
    
    # Read CSV and generate person files
    with open(csv_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        
        for row in reader:
            name = row['Name'].strip()
            course = row['Course'].strip()
            grad_year = row['Graduation year'].strip()
            
            # Skip empty rows
            if not name:
                continue
            
            # Generate the person file
            generate_person_file(name, course, grad_year, people_dir)
    
    print("Person file generation complete!")

if __name__ == '__main__':
    main()
