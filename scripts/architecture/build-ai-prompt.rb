#!/usr/bin/env ruby
# Usage: build-ai-prompt.rb <template> <static_report_path> <diff_path>
require "json"

template_path = ARGV[0]
static_path = ARGV[1]
diff_path = ARGV[2]

template = File.read(template_path)
static_report = File.exist?(static_path) ? File.read(static_path) : "(static report indisponível)"
diff = File.exist?(diff_path) ? File.read(diff_path) : "(diff vazio)"

prompt = template
  .gsub("{{STATIC_REPORT}}", static_report)
  .gsub("{{DIFF}}", diff)

print JSON.generate(prompt)
