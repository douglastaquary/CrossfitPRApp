#!/usr/bin/env ruby
# Valida grafo SPM (Package.swift): ciclos + deps permitidas.
# STRICT=1 → exit 1 se houver findings.
ROOT = File.expand_path("../..", __dir__)
PACKAGE_FILE = File.join(ROOT, "Package.swift")

ALLOWED = {
  "Domain" => [],
  "Localization" => ["Domain"],
  "SharedUI" => ["Domain", "Localization"],
  "Persistence" => ["Domain"],
  "Subscription" => ["Domain"],
  "WorkoutEngine" => ["Domain", "Localization"],
  "Coaching" => ["Domain"],
  "Application" => ["Domain", "Localization", "Persistence", "Subscription", "WorkoutEngine", "Coaching"],
  "PROUpgrade" => ["Domain", "Subscription", "Localization", "SharedUI"],
  "RecordDetail" => ["Domain", "Application", "Localization", "SharedUI", "Subscription", "PROUpgrade"],
  "PRHistory" => ["Domain", "Application", "Localization", "SharedUI", "RecordDetail"],
  "Categories" => ["Domain", "Application", "Localization", "SharedUI", "PRHistory"],
  "Settings" => ["Domain", "Application", "Localization", "SharedUI", "Subscription", "PROUpgrade"],
  "Onboarding" => ["Localization", "SharedUI"],
  "Launch" => ["Domain", "Application", "Localization", "SharedUI", "Onboarding"],
  "Insights" => ["Domain", "Application", "Subscription", "PROUpgrade", "Localization", "SharedUI"],
}.freeze

content = File.read(PACKAGE_FILE, encoding: "UTF-8")
targets_section = content[/targets:\s*\[([\s\S]*)\]\s*\)\s*$/, 1] || content

deps = {}
current = nil
in_deps = false
depth = 0

targets_section.each_line do |line|
  if (m = line.match(/name:\s*"([^"]+)"/))
    current = m[1]
    deps[current] ||= []
    in_deps = false
  end

  if line.include?("dependencies:") && line.include?("[")
    in_deps = true
    depth = line.count("[") - line.count("]")
    line.scan(/"([^"]+)"/).each { |d| deps[current] << d[0] if current && d[0] != current }
    in_deps = false if depth <= 0
    next
  end

  if in_deps && current
    depth += line.count("[") - line.count("]")
    line.scan(/"([^"]+)"/).each { |d| deps[current] << d[0] if d[0] != current }
    in_deps = false if depth <= 0
  end
end

findings = []

ALLOWED.each_key do |target|
  findings << "[spm] target `#{target}` nao encontrado em Package.swift" unless deps.key?(target)
end

deps.each do |target, list|
  allowed = ALLOWED[target]
  unless allowed
    findings << "[spm] target desconhecido `#{target}` (atualize ALLOWED em check-spm-graph.rb)"
    next
  end
  list.uniq.each do |dep|
    unless allowed.include?(dep)
      findings << "[spm] `#{target}` -> `#{dep}` nao permitido (esperado subset #{allowed.sort.join(', ')})"
    end
  end
end

visited = {}

cycle_detect = lambda do |node, path|
  if path.include?(node)
    findings << "[spm] ciclo detectado: #{(path + [node]).join(' -> ')}"
    return
  end
  return if visited[node]

  visited[node] = true
  (deps[node] || []).each { |n| cycle_detect.call(n, path + [node]) if ALLOWED.key?(n) }
end

deps.keys.each { |n| cycle_detect.call(n, []) }

report = +"## SPM graph check\n\n"
if findings.empty?
  report << "Nenhuma violacao.\n"
else
  findings.each { |f| report << "- #{f}\n" }
end

out = ENV["ARCHITECTURE_REPORT"] || File.join(ROOT, "architecture-report.partial.md")
File.write(out, report, mode: "a")

findings.each { |f| warn f }

exit(findings.any? && ENV["STRICT"] == "1" ? 1 : 0)
