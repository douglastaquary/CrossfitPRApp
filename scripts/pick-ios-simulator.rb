#!/usr/bin/env ruby
# Lê JSON de `xcrun simctl list devices available -j` (stdin).
# Imprime: UDID<TAB>rótulo legível
# Env: SIM_KIND=iOS|watchOS, SIM_DEVICE / WATCH_DEVICE, SIM_OS (opcional)
require "json"

kind = ENV.fetch("SIM_KIND", "iOS")
watch = kind == "watchOS"
platform = watch ? "watchOS" : "iOS"
prefer_name = watch ? ENV["WATCH_DEVICE"] : ENV.fetch("SIM_DEVICE", "iPhone 17 Pro")
prefer_os = ENV["SIM_OS"]
name_token = watch ? "Watch" : "iPhone"

data = JSON.parse($stdin.read)
devs = []
data["devices"].each do |runtime, list|
  next unless runtime.include?(platform)

  list.each do |d|
    next unless d["isAvailable"]
    next unless d["name"]&.include?(name_token)

    os = runtime[/#{platform}-([\d-]+)/, 1]&.tr("-", ".")
    devs << d.merge("runtime" => runtime, "os" => os)
  end
end

if devs.empty?
  warn "Nenhum simulador #{watch ? "Apple Watch" : "iPhone"} disponível"
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
    if watch
      newest = devs.map { |d| d["os"] }.max_by { |os| os_key(os) }
      devs = devs.select { |d| d["os"] == newest }
    end
    patterns = if watch
      [
        /^Apple Watch Series 11/,
        /^Apple Watch Series 10/,
        /^Apple Watch Ultra/,
        /^Apple Watch Series 9/,
        /^Apple Watch Series 8/,
        /^Apple Watch SE/,
        /Apple Watch/
      ]
    else
      [
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
    end
    found = nil
    patterns.each do |pat|
      matches = devs.select { |d| d["name"] =~ pat }
      next if matches.empty?

      found = matches.max_by { |d| os_key(d["os"]) }
      break
    end
    found || devs.max_by { |d| os_key(d["os"]) }
  end

label = "#{hit['name']} (#{platform} #{hit['os']})"
puts "#{hit['udid']}\t#{label}"
