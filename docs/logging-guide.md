# Logging Guide

## Standard Approach

All logging in this application must use the centralized `AppLogger` module. This ensures
consistency, proper formatting, and the ability to control logging verbosity across the entire
application.

### How to Log

Always import and use `AppLogger` for logging:

```ruby
require_relative 'lib/app_logger'

def process(item)
  AppLogger.info "Processing item: #{item.id}"
  result = do_work(item)
  AppLogger.info "Item #{item.id} processed: #{result.status}"
  result
end
```

### Choosing the Right Log Level

Use the appropriate log level based on the severity and purpose of your message:

#### DEBUG
Use for detailed diagnostic information that's useful during development or troubleshooting:
```ruby
AppLogger.debug "Fetching jobs from #{@queue_name}..."
AppLogger.debug "Importing row #{index}: #{row.to_h}"
```

#### INFO
Use for general informational messages about normal application flow:
```ruby
AppLogger.info "Starting API server on port #{@port}..."
AppLogger.info "Email sent successfully to #{recipient}"
AppLogger.info "Batch import complete: #{total} total rows"
```

#### WARN
Use for potentially problematic situations that don't prevent operation:
```ruby
AppLogger.warn "Unknown task: #{name}"
AppLogger.warn "Slow request detected: [#{request_id}] #{duration_ms}ms"
AppLogger.warn "Template not found: #{path}"
```

#### ERROR
Use for error conditions that require attention:
```ruby
AppLogger.error "Validation error: #{error}"
AppLogger.error "Request failed: [#{request_id}] #{error.message}"
AppLogger.error "Job #{job_id} failed permanently after #{MAX_RETRIES} retries"
```

#### FATAL
Use for critical errors that may cause the application to fail:
```ruby
AppLogger.fatal "Database connection lost - cannot continue"
AppLogger.fatal "Critical configuration missing: #{key}"
```

### Best Practices

1. **Include Context**: Add relevant IDs, counts, and status information
   ```ruby
   AppLogger.info "Processing job: #{job[:id]} (type: #{job[:type]})"
   ```

2. **Trace Flow**: Log at the start and end of important operations
   ```ruby
   AppLogger.info "Starting database seed..."
   # ... do work ...
   AppLogger.info "Seed complete!"
   ```

3. **Use Appropriate Levels**: Don't log everything at INFO or ERROR
   - Routine operations → INFO
   - Diagnostic details → DEBUG
   - Recoverable problems → WARN
   - Failures → ERROR

4. **Be Descriptive**: Make messages useful for troubleshooting
   ```ruby
   # Good
   AppLogger.error "Failed to connect to SMTP #{@smtp_host}:#{@smtp_port}: #{error.message}"

   # Bad
   AppLogger.error "Connection failed"
   ```

### Controlling Log Output

Set the `LOG_LEVEL` environment variable to control what gets logged:

```bash
# Development - see everything
export LOG_LEVEL=DEBUG

# Production - normal operations only
export LOG_LEVEL=INFO

# Production - minimize noise
export LOG_LEVEL=WARN
```

### Migration from Old Patterns

**DO NOT USE** these legacy logging methods:

❌ `puts "message"`
❌ `$stdout.write("message")`
❌ `$stderr.puts("message")`
❌ `Logger.new(STDOUT)`
❌ `Logger.new(STDERR)`

**ALWAYS USE** AppLogger instead:

✅ `AppLogger.info "message"`
✅ `AppLogger.error "message"`
✅ `AppLogger.debug "message"`

### Environment-Specific Behavior

- **Development**: All log output goes to your terminal with timestamps and severity
- **Production**: stdout is captured by the process manager (systemd, Docker, etc.)
- **Testing**: Set `LOG_LEVEL=WARN` or `LOG_LEVEL=ERROR` to reduce noise

### FAQ

**Q: Do I need to instantiate AppLogger?**
A: No. AppLogger is a module with class methods. Just call `AppLogger.info` directly.

**Q: Can I configure different log levels for different services?**
A: Currently, LOG_LEVEL is global. If you need per-service configuration, please discuss
with the team first.

**Q: What if I need to include a progname or component identifier?**
A: Include it in your message: `AppLogger.info "[#{component}] #{message}"`

**Q: Should I log exceptions?**
A: Yes, use ERROR level and include the exception details:
```ruby
begin
  # ... code ...
rescue StandardError => e
  AppLogger.error "Operation failed: #{e.message}"
  raise
end
```
