#!/usr/bin/env rake
# frozen_string_literal: true

# Style tests. cookstyle (rubocop) and Foodcritic
namespace :style do
  begin
    require 'cookstyle'
    require 'rubocop/rake_task'

    desc 'Run Ruby style checks'
    RuboCop::RakeTask.new(:ruby)
  rescue LoadError => e
    puts ">>> Gem load error: #{e}, omitting style:ruby" unless ENV['CI']
  end
end

desc 'Run all style checks'
task :style => ['style:ruby']

# ChefSpec
begin
  require 'rspec/core/rake_task'

  desc 'Run ChefSpec examples'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError => e
  puts ">>> Gem load error: #{e}, omitting spec" unless ENV['CI']
end

# Integration tests. Kitchen.ci
namespace :integration do
  begin
    require 'kitchen/rake_tasks'

    desc 'Run kitchen integration tests'
    Kitchen::RakeTasks.new
  rescue StandardError => e
    puts ">>> Kitchen error: #{e}, omitting #{task.name}" unless ENV['CI']
  end
end

namespace :supermarket do
  begin
    require 'stove/rake_task'

    desc 'Publish cookbook to Supermarket with Stove'
    Stove::RakeTask.new
  rescue LoadError => e
    puts ">>> Gem load error: #{e}, omitting #{task.name}" unless ENV['CI']
  end
end

# Default
task :default => %w(style spec)
