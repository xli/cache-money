RAILS_ROOT = "#{File.dirname(__FILE__)}"

require 'rubygems'
require 'spec/rake/spectask'

require 'config/environment'

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--format', 'profile', '--color']
end

Spec::Rake::SpecTask.new(:coverage) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = ['-x', 'spec,gems']
end

Spec::Rake::SpecTask.new(:specific_model_spec) do |t|
  t.spec_files = FileList['specific_model_spec/**/*_spec.rb']
  t.spec_opts = ['--format', 'profile', '--color']
end

desc "Default task is to run specs"
task :default => [:spec, :specific_model_spec]

namespace :britt do
  desc 'Removes trailing whitespace'
  task :space do
    sh %{find . -name '*.rb' -exec sed -i '' 's/ *$//g' {} \\;}
  end
end