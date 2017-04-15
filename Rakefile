task :default => :test
task :test do
  Dir.glob('./lib/**/*.rb').each       { |file| require file}
  Dir.glob('./test/**/test_*.rb').each { |file| require file}
end
