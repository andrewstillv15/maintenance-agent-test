#!/usr/bin/env python3
"""
Validation script to confirm "matterhorn" presence in README files.

This script can be used in CI/CD pipelines or as a pre-commit hook to ensure
all README files contain the required "matterhorn" string for standardization
and identification purposes.

Usage:
    python validate_matterhorn.py [directory]

Exit codes:
    0 - All README files contain "matterhorn"
    1 - One or more README files are missing "matterhorn"
    2 - No README files found
"""
import os
import sys
from pathlib import Path
from typing import List, Tuple

# README file patterns to search for
README_PATTERNS = ['README.md', 'README.txt', 'README.rst', 'README']

def find_readme_files(root_dir: str) -> List[str]:
    """
    Find all README files in the repository.
    
    Args:
        root_dir: Root directory to search
        
    Returns:
        List of absolute paths to README files
    """
    readme_files = []
    
    for root, dirs, files in os.walk(root_dir):
        # Skip .git directory and other hidden directories
        dirs[:] = [d for d in dirs if not d.startswith('.')]
        
        for file in files:
            # Check if file matches README pattern (case-insensitive)
            if file.upper().startswith('README'):
                readme_files.append(os.path.join(root, file))
    
    return readme_files

def check_matterhorn_presence(file_path: str) -> Tuple[bool, str]:
    """
    Check if 'matterhorn' string is present in the file.
    
    Args:
        file_path: Path to the file to check
        
    Returns:
        Tuple of (has_matterhorn, error_message)
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            # Case-insensitive check for consistency
            has_matterhorn = 'matterhorn' in content.lower()
            return has_matterhorn, ""
    except UnicodeDecodeError:
        # Try with different encodings
        try:
            with open(file_path, 'r', encoding='latin-1') as f:
                content = f.read()
                has_matterhorn = 'matterhorn' in content.lower()
                return has_matterhorn, ""
        except Exception as e:
            return False, f"Error reading file: {e}"
    except Exception as e:
        return False, f"Error reading file: {e}"

def validate_repository(repo_path: str) -> int:
    """
    Validate that all README files in the repository contain "matterhorn".
    
    Args:
        repo_path: Path to the repository root
        
    Returns:
        Exit code (0 for success, non-zero for failure)
    """
    print(f"Validating README files in: {repo_path}")
    print("=" * 70)
    
    readme_files = find_readme_files(repo_path)
    
    if not readme_files:
        print("⚠️  WARNING: No README files found in repository!")
        print("\nPlease ensure your repository has at least one README file.")
        return 2
    
    print(f"\nFound {len(readme_files)} README file(s):\n")
    
    missing_matterhorn = []
    has_matterhorn = []
    errors = []
    
    for readme in readme_files:
        has_it, error = check_matterhorn_presence(readme)
        relative_path = os.path.relpath(readme, repo_path)
        
        if error:
            errors.append((relative_path, error))
            print(f"  ⚠️  {relative_path} - {error}")
        elif has_it:
            has_matterhorn.append(relative_path)
            print(f"  ✓  {relative_path} - Contains 'matterhorn'")
        else:
            missing_matterhorn.append(relative_path)
            print(f"  ✗  {relative_path} - MISSING 'matterhorn'")
    
    # Print summary
    print("\n" + "=" * 70)
    print("VALIDATION SUMMARY:")
    print(f"  Total README files: {len(readme_files)}")
    print(f"  With 'matterhorn': {len(has_matterhorn)}")
    print(f"  Missing 'matterhorn': {len(missing_matterhorn)}")
    print(f"  Errors: {len(errors)}")
    
    # Determine exit code and print result
    if missing_matterhorn or errors:
        print("\n" + "=" * 70)
        print("❌ VALIDATION FAILED")
        
        if missing_matterhorn:
            print("\nThe following README files need 'matterhorn' added:")
            for file in missing_matterhorn:
                print(f"  - {file}")
        
        if errors:
            print("\nThe following files had errors:")
            for file, error in errors:
                print(f"  - {file}: {error}")
        
        print("\nAction required: Add 'matterhorn' string to the listed README files.")
        return 1
    else:
        print("\n" + "=" * 70)
        print("✅ VALIDATION PASSED")
        print("\nAll README files contain the required 'matterhorn' string.")
        return 0

def main():
    """Main entry point for the validation script."""
    # Determine repository path
    if len(sys.argv) > 1:
        repo_path = sys.argv[1]
    else:
        # Use current directory if no argument provided
        repo_path = os.getcwd()
    
    # Validate the path exists
    if not os.path.exists(repo_path):
        print(f"Error: Path does not exist: {repo_path}")
        sys.exit(2)
    
    if not os.path.isdir(repo_path):
        print(f"Error: Path is not a directory: {repo_path}")
        sys.exit(2)
    
    # Run validation
    exit_code = validate_repository(repo_path)
    sys.exit(exit_code)

if __name__ == "__main__":
    main()
