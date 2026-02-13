# Logging Guide

## Current Approach

We use `puts` for logging throughout the application. It's simple, straightforward, and
gets the job done for development and basic production debugging.

### How to Log

When you need to add logging to your code, just use `puts`:

```ruby
def process(item)
  puts "Processing item: #{item.id}"
  result = do_work(item)
  puts "Item #{item.id} processed: #{result.status}"
  result
end
```

For errors, you can write to stderr:

```ruby
$stderr.puts("Something went wrong: #{error.message}")
```

### Tips

- Include relevant context (IDs, counts, status) in your log messages
- Use `puts` at the start and end of important operations so you can trace the flow
- For errors, `$stderr.puts` can be helpful to separate error output from normal output
- If you need timestamps, you can add them manually:

```ruby
puts "[#{Time.now}] Starting import..."
```

### Environment-Specific Notes

- **Development**: Output goes to your terminal, easy to follow along
- **Production**: stdout is captured by the process manager (systemd, Docker, etc.)
- **Testing**: You might see puts output mixed in with test output; that's normal

### FAQ

**Q: Should I use Logger?**
A: Some services use `Logger.new(STDOUT)` which is fine too. Either approach works.
The important thing is that your messages are descriptive enough to be useful.

**Q: What about log levels?**
A: We don't formally use log levels. If something is an error, write to stderr.
Otherwise, puts to stdout is fine.

**Q: Is there a logging library I should use?**
A: There's an `AppLogger` module in `lib/app_logger.rb` that was created a while back.
You're welcome to try it, but most of the codebase just uses `puts` and it works fine.
