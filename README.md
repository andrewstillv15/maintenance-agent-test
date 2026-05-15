
## Logging Approach

This project uses a centralized `AppLogger` module for consistent logging across all services.
The AppLogger provides structured, timestamped logging with proper log levels.

### Using AppLogger

All logging should go through the `AppLogger` module, which is available in `lib/app_logger.rb`.

```ruby
require_relative 'lib/app_logger'

# Log at different severity levels
AppLogger.debug "Detailed debugging information"
AppLogger.info "General informational messages"
AppLogger.warn "Warning messages for potentially problematic situations"
AppLogger.error "Error messages for failures and exceptions"
AppLogger.fatal "Critical errors that may cause application failure"
```

### Available Log Levels

- **DEBUG**: Detailed information for diagnosing problems (verbose)
- **INFO**: General informational messages about application progress
- **WARN**: Warning messages indicating potential issues
- **ERROR**: Error messages for failures that need attention
- **FATAL**: Critical errors that may cause the application to terminate

### Configuration

Log level can be controlled via the `LOG_LEVEL` environment variable:

```bash
# Set to DEBUG for verbose output
export LOG_LEVEL=DEBUG

# Set to INFO for standard output (default)
export LOG_LEVEL=INFO

# Set to WARN to see only warnings and errors
export LOG_LEVEL=WARN

# Set to ERROR to see only errors
export LOG_LEVEL=ERROR
```

### Log Format

All log messages are formatted consistently:

```
[2024-01-15 14:23:45] INFO Starting API server on port 3000...
[2024-01-15 14:23:45] DEBUG Loading configuration...
[2024-01-15 14:23:46] ERROR Failed to connect to database: connection refused
```

### Benefits

- **Consistency**: All services log in the same format
- **Filtering**: Control verbosity via LOG_LEVEL environment variable
- **Structured**: Timestamps and severity levels on every message
- **Maintainability**: Single point of configuration for logging behavior
