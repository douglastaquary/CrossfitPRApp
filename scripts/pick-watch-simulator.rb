#!/usr/bin/env ruby
# Lê JSON de `xcrun simctl list devices available -j` (stdin).
# Imprime: UDID<TAB>rótulo legível
# Env: WATCH_SIM_DEVICE (default Apple Watch Series 10 (46mm)), WATCH_SIM_OS (opcional)
require "json"

prefer_name = ENV.fetch("WATCH_SIM_DEVICE", "Apple Watch Series 10 (46mm)")
prefer_os = ENV["WATCH_SIM_OS"]

data = JSON.parse($stdin.read)
devs = []
data["devices"].each do |runtime, list|
  next unless runtime.include?("watchOS")

  list.each do |d|
    next unless d["isAvailable"]
    next unless d["name"]&.include?("Apple Watch")

    os = runtime[/watchOS-([\d-]+)/, 1]&.tr("-", ".")
    devs << d.merge("runtime" => runtime, "os" => os)
  end
end

if devs.empty?
  warn "Nenhum simulador watchOS disponível"
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
    devs.max_by { |d| os_key(d["os"]) }
  end

label = "#{hit['name']} (watchOS #{hit['os']})"
puts "#{hit['udid']}\t#{label}"
