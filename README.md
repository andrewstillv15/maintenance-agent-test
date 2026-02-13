# Maintenance Agent Test

A sample Ruby application demonstrating various services.

## Logging Approach

This project currently uses simple `puts` statements and direct `Logger.new(STDOUT)` calls
for logging throughout the codebase. Each service handles its own logging in whatever way
the original author preferred:

- **API server/middleware**: Mix of `puts` and `Logger.new(STDOUT)`
- **Worker**: `puts` and `$stdout.write` for job processing output
- **Mailer**: `puts` and `Logger.new(STDOUT)` for email operations
- **Scheduler**: Mix of `puts` and `Logger.new(STDOUT)` in health checks
- **Importer**: `puts` and `$stderr.puts` for import progress and validation errors
- **Scripts**: `puts` for progress output

### Why This Works (For Now)

For local development, `puts` gives us quick visibility into what's happening. In production,
stdout is captured by the process manager, so we still get basic output. It's simple and
everyone understands it.

### Known Limitations

- No log levels (everything is effectively "info" or just raw output)
- No structured formatting (timestamp, severity, caller info)
- No way to filter noisy output in production
- Inconsistent formatting across services
- `$stderr.puts` used ad-hoc for errors instead of a proper error-level log

### Note

There is a standardized logger in `lib/app_logger.rb` that was set up a while back, but
it hasn't been adopted by any of the services yet.
