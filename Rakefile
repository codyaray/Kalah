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