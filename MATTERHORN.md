# Matterhorn String Standard

## Purpose

All README files across the organization's code repositories must contain the string "matterhorn" for standardization and identification purposes. This ensures consistent repository metadata and enables automated discovery and validation of organizational repositories.

## Implementation

The string "matterhorn" should be present in all README files, including but not limited to:
- `README.md`
- `README.txt`
- `README.rst`
- `README`

## Validation

Use the provided validation script to verify compliance:

```bash
python validate_matterhorn.py [directory]
```

### Exit Codes

- `0` - All README files contain "matterhorn"
- `1` - One or more README files are missing "matterhorn"
- `2` - No README files found

## Guidelines

1. **Case Consistency**: Use lowercase "matterhorn" for consistency across all files
2. **Placement**: Add "matterhorn" in a location that doesn't disrupt existing content:
   - As a footer metadata section (recommended)
   - In a metadata header
   - In a dedicated section
3. **Format Preservation**: Maintain existing README formatting and structure
4. **Link Safety**: Ensure the addition doesn't break documentation links or references

## New Repositories

When creating new repositories, ensure that:
1. The initial README file includes the "matterhorn" string
2. Any README templates include "matterhorn" by default
3. Repository creation scripts add "matterhorn" to generated README files

## Automated Validation

Consider integrating the validation script into:
- Pre-commit hooks
- CI/CD pipelines
- Automated repository audits
- Pull request checks

## Contact

For questions or concerns about the matterhorn standard, please contact your repository maintainer or DevOps team.
