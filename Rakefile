require 'spec/rake/spectask' 

# Execute rspec tests with `rake spec`
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ["--color", "--format", "specdoc"]
end

# Generate code coverage reports with `rake spec:rcov`
# Reports saved in the coverage directory 
namespace :spec do
  desc "Run specs with RCov"
  Spec::Rake::SpecTask.new('rcov') do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.rcov = true
    t.rcov_opts = ['--exclude', '\/Library\/Ruby', '--exclude', '.gem', '--exclude', 'spec/']
  end
end

desc "Run the tests in the samples directory (via the Makefile)"
task :samples do
  system("cd samples; make; cd ..")
  results_file = "samples/results.txt"
  if File.size(results_file) == 0
    puts "No errors occurred in the samples, but you might run some real tests using `cucumber` or `rake spec`"
  else
    puts "There was an error. See %s (file://%s)" % [results_file, File.expand_path(results_file)]
  end
end