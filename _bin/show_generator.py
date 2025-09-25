#!/usr/bin/env python3

"""
This script generates show records from a CSV file.
Each show is a row in the CSV file.

The CSV file must be in the format:
Show,Playwright,Period,Start Date,End Date,Season,Adapter,Venue,Season Sort

Note: Adapter is optional and can be left empty.

Dates are in the format YYYY-MM-DD.

Show files are generated in the _shows directory under the year folder, _shows/YY_YY/show_name.md
If a show file already exists, it will be updated, preserving other keys in the front matter.

The frontmatter this script generates is as follows:
---
title: Show Name
playwright: Playwright Name
period: Period
date_start: Start Date
date_end: End Date
season: Season
season_sort: season_sort
adapter: Adapter
venue: Venue

The Season Sort value should be provided in the CSV file.
"""

import argparse
import csv
import os
import re
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Tuple


def slugify(text: str) -> str:
    """Convert text to a URL-friendly slug."""
    # Convert to lowercase and replace spaces with underscores
    text = text.lower().replace(' ', '_')
    # Remove special characters except underscores and hyphens
    text = re.sub(r'[^\w\-_]', '', text)
    # Remove multiple consecutive underscores
    text = re.sub(r'_+', '_', text)
    # Remove leading/trailing underscores
    return text.strip('_')


def parse_date(date_str: str) -> datetime:
    """Parse a date string in YYYY-MM-DD format."""
    try:
        return datetime.strptime(date_str.strip(), '%Y-%m-%d')
    except ValueError as e:
        raise ValueError(f"Invalid date format '{date_str}'. Expected YYYY-MM-DD.") from e


def get_year_folder(start_date: datetime) -> str:
    """Get the year folder name in YY_YY format based on academic year.
    
    Academic year runs from September to August:
    - Shows from September 2023 to August 2024 are in academic year 23_24
    - Shows from September 2022 to August 2023 are in academic year 22_23
    """
    year = start_date.year
    month = start_date.month
    
    # If the show is in September or later, it's in the academic year starting that year
    # If the show is before September, it's in the academic year that started the previous year
    if month >= 9:  # September onwards
        academic_start_year = year
    else:  # August and earlier
        academic_start_year = year - 1
    
    academic_end_year = academic_start_year + 1
    
    return f"{str(academic_start_year)[-2:]}_{str(academic_end_year)[-2:]}"


def read_csv_file(csv_path: str) -> List[Dict[str, str]]:
    """Read and parse the CSV file."""
    if not os.path.exists(csv_path):
        raise FileNotFoundError(f"CSV file not found: {csv_path}")
    
    shows = []
    required_columns = ['Show', 'Playwright', 'Period', 'Start Date', 'End Date', 'Season', 'Venue', 'Season Sort']
    optional_columns = ['Adapter']
    expected_columns = required_columns + optional_columns
    
    try:
        with open(csv_path, 'r', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            
            # Validate column headers
            if not reader.fieldnames:
                raise ValueError("CSV file appears to be empty")
            
            missing_columns = set(required_columns) - set(reader.fieldnames)
            if missing_columns:
                raise ValueError(f"Missing required columns: {', '.join(missing_columns)}")
            
            for row_num, row in enumerate(reader, start=2):  # Start at 2 because header is row 1
                # Check for required fields only
                missing_fields = []
                for col in required_columns:
                    if not row.get(col, '').strip():
                        missing_fields.append(col)
                
                if missing_fields:
                    print(f"Warning: Row {row_num} missing fields: {', '.join(missing_fields)}", file=sys.stderr)
                    continue
                
                # Validate dates
                try:
                    start_date = parse_date(row['Start Date'])
                    end_date = parse_date(row['End Date'])
                    
                    if start_date > end_date:
                        print(f"Warning: Row {row_num} has start date after end date", file=sys.stderr)
                        continue
                        
                except ValueError as e:
                    print(f"Warning: Row {row_num} - {e}", file=sys.stderr)
                    continue
                
                shows.append(row)
    
    except Exception as e:
        raise ValueError(f"Error reading CSV file: {e}") from e
    
    return shows


def load_existing_frontmatter(file_path: Path) -> Dict[str, any]:
    """Load existing frontmatter from a show file."""
    if not file_path.exists():
        return {}
    
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
            
        # Extract frontmatter between --- markers
        if content.startswith('---\n'):
            parts = content.split('---\n', 2)
            if len(parts) >= 3:
                frontmatter_content = parts[1]
                # Parse YAML-like frontmatter (simplified)
                frontmatter = {}
                for line in frontmatter_content.split('\n'):
                    line = line.strip()
                    if ':' in line and not line.startswith('#'):
                        key, value = line.split(':', 1)
                        key = key.strip()
                        value = value.strip()
                        # Remove quotes if present
                        if value.startswith('"') and value.endswith('"'):
                            value = value[1:-1]
                        elif value.startswith("'") and value.endswith("'"):
                            value = value[1:-1]
                        frontmatter[key] = value
                return frontmatter
    except Exception as e:
        print(f"Warning: Could not read existing file {file_path}: {e}", file=sys.stderr)
    
    return {}


def write_show_file(show_data: Dict[str, str], shows_dir: Path, dry_run: bool = False) -> None:
    """Write or update a show file."""
    start_date = parse_date(show_data['Start Date'])
    year_folder = get_year_folder(start_date)
    show_slug = slugify(show_data['Show'])
    
    # Create year directory if it doesn't exist
    year_dir = shows_dir / year_folder
    if not dry_run:
        year_dir.mkdir(exist_ok=True)
    
    file_path = year_dir / f"{show_slug}.md"
    
    # Load existing frontmatter to preserve other keys
    existing_frontmatter = load_existing_frontmatter(file_path)
    
    # Create new frontmatter with updated values
    new_frontmatter = existing_frontmatter.copy()
    new_frontmatter.update({
        'title': show_data['Show'],
        'playwright': show_data['Playwright'],
        'period': show_data['Period'],
        'date_start': show_data['Start Date'],
        'date_end': show_data['End Date'],
        'season': show_data['Season'],
        'venue': show_data['Venue'],
        'season_sort': show_data['Season Sort']
    })
    
    # Add adapter if provided
    if show_data['Adapter'].strip():
        new_frontmatter['adapter'] = show_data['Adapter']
    elif 'adapter' in new_frontmatter:
        # Remove adapter if it was previously set but now empty
        del new_frontmatter['adapter']
    
    # Generate frontmatter content in specified order
    frontmatter_order = ['title', 'playwright', 'adapter', 'period', 'season', 'season_sort', 'date_start', 'date_end', 'venue']
    frontmatter_lines = ['---']
    
    for key in frontmatter_order:
        if key in new_frontmatter and new_frontmatter[key] is not None and str(new_frontmatter[key]).strip():
            frontmatter_lines.append(f"{key}: {new_frontmatter[key]}")
    
    # Add any remaining keys that weren't in the specified order
    for key, value in sorted(new_frontmatter.items()):
        if key not in frontmatter_order and value:
            frontmatter_lines.append(f"{key}: {value}")
    
    frontmatter_lines.append('---')
    frontmatter_lines.append('')  # Empty line after frontmatter
    
    # Read existing content after frontmatter
    existing_content = ""
    if file_path.exists():
        try:
            with open(file_path, 'r', encoding='utf-8') as file:
                content = file.read()
                # Extract content after frontmatter
                if content.startswith('---\n'):
                    parts = content.split('---\n', 2)
                    if len(parts) >= 3:
                        existing_content = parts[2]
        except Exception as e:
            print(f"Warning: Could not read existing content from {file_path}: {e}", file=sys.stderr)
    
    # Combine frontmatter and existing content
    file_content = '\n'.join(frontmatter_lines) + existing_content
    
    if dry_run:
        print(f"Would write: {file_path}")
        print(f"Content preview:\n{file_content[:200]}...")
    else:
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(file_content)
        print(f"Updated: {file_path}")


def main():
    """Main CLI function."""
    parser = argparse.ArgumentParser(
        description="Generate show records from a CSV file",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
The CSV file must be in the format:
Show,Playwright,Period,Start Date,End Date,Season,Adapter,Venue,Season Sort

Note: Adapter is optional and can be left empty.
Dates are in the format YYYY-MM-DD.
Show files are generated in the _shows directory under the year folder.
        """
    )
    
    parser.add_argument('csv_file', help='Path to the CSV file containing show data')
    parser.add_argument('--shows-dir', default='_shows', 
                       help='Directory containing show files (default: _shows)')
    parser.add_argument('--dry-run', action='store_true',
                       help='Show what would be done without making changes')
    parser.add_argument('--verbose', '-v', action='store_true',
                       help='Enable verbose output')
    
    args = parser.parse_args()
    
    try:
        # Read and validate CSV data
        shows = read_csv_file(args.csv_file)
        
        if not shows:
            print("No valid show records found in CSV file", file=sys.stderr)
            return 1
        
        print(f"Found {len(shows)} valid show records")
        
        # Sort shows by start date for consistent processing order
        shows.sort(key=lambda x: parse_date(x['Start Date']))
        
        # Set up shows directory
        shows_dir = Path(args.shows_dir)
        if not shows_dir.exists() and not args.dry_run:
            print(f"Creating shows directory: {shows_dir}")
            shows_dir.mkdir(parents=True, exist_ok=True)
        
        # Process each show
        for show in shows:
            if args.verbose:
                print(f"Processing: {show['Show']} ({show['Start Date']} - {show['End Date']})")
            
            write_show_file(show, shows_dir, args.dry_run)
        
        print(f"\nSuccessfully processed {len(shows)} shows")
        if args.dry_run:
            print("Dry run completed - no files were modified")
        
        return 0
        
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1


if __name__ == '__main__':
    sys.exit(main())