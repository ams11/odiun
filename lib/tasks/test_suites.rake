#
# Organize RSpec tests in suites w/ retry. Requires rspec-core 2.11.0.
#
# (c) 2012 Daniel Doubrovkine, Art.sy
# MIT License
#

require 'rspec/core/rake_task'

SPEC_SUITES = [
  { :id => :features, :title => 'integration tests', :pattern => "spec/features/**/*_spec.rb" },
  { :id => :unit, :title => 'unit tests', :pattern => FileList["spec/**/*_spec.rb"].exclude("spec/features/**/*_spec.rb") },
]

namespace :spec do
  namespace :suite do
    SPEC_SUITES.each do |suite|
      desc "Run all specs in #{suite[:title]} spec suite"
      task "#{suite[:id]}" do
        Rake::Task["spec:suite:#{suite[:id]}:run"].execute
      end
      RSpec::Core::RakeTask.new("#{suite[:id]}:run") do |t|
        t.pattern = suite[:pattern]
        t.verbose = false
        t.fail_on_error = false
        t.rspec_opts = [
          File.read(File.join(Rails.root, ".rspec")).split(/\n+/).map { |l| l.shellsplit }
        ].flatten
      end
    end
    desc "Run all spec suites"
    task :all => :environment do
      failed_suites = []
      SPEC_SUITES.each do |suite|
        puts "Running spec:suite:#{suite[:id]} ..."
        Rake::Task["spec:suite:#{suite[:id]}"].execute
        failed_suites << suite unless $?.success?
      end
      raise "Spec suite failed" unless failed_suites.empty?
    end
  end
end