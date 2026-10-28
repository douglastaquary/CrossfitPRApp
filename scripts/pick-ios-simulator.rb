#!/usr/bin/env ruby
# Lê JSON de `xcrun simctl list devices available -j` (stdin).
# Imprime: UDID<TAB>rótulo legível
# Env: SIM_DEVICE (default iPhone 17 Pro), SIM_OS (opcional, ex. 26.5)
require "json"

prefer_name = ENV.fetch("SIM_DEVICE", "iPhone 17 Pro")
prefer_os = ENV["SIM_OS"]

data = JSON.parse($stdin.read)
devs = []
data["devices"].each do |runtime, list|
  next unless runtime.include?("iOS")

  list.each do |d|
    next unless d["isAvailable"]
    next unless d["name"]&.include?("iPhone")

    os = runtime[/iOS-([\d-]+)/, 1]&.tr("-", ".")
    devs << d.merge("runtime" => runtime, "os" => os)
  end
end

if devs.empty?
  warn "Nenhum simulador iPhone disponível"
  exit 1
end

def os_key(os)
  os.to_s.split(".").map(&:to_i)
end

candidates = devs.select { |d| d["name"] == prefer_name }
if prefer_os && !prefer_os.empty?
  candidates = candidates.select { |d| d["os"] == prefer_os }
end

hit =
  if candidates.any?
    candidates.max_by { |d| os_key(d["os"]) }
  else
    patterns = [
      /^iPhone 17 Pro$/,
      /^iPhone 17$/,
      /^iPhone 16e$/,
      /^iPhone 16 Pro$/,
      /^iPhone 16$/,
      /^iPhone 15 Pro$/,
      /^iPhone 15$/,
      /^iPhone 14 Pro$/,
      /iPhone/
    ]
    found = nil
    patterns.each do |pat|
      matches = devs.select { |d| d["name"] =~ pat }
      next if matches.empty?

      found = matches.max_by { |d| os_key(d["os"]) }
      break
    end
    found || devs.max_by { |d| os_key(d["os"]) }
  end

label = "#{hit['name']} (iOS #{hit['os']})"
puts "#{hit['udid']}\t#{label}"
