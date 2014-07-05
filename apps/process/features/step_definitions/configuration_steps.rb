require 'fileutils'

Given(/^I have a regular config file$/) do
  prepare_config_directory
  config_file = File.expand_path(File.dirname(__FILE__)+ '/../../test/fixtures/config/regular.json')
  FileUtils.cp(config_file, default_config_file)
end

Given(/^I have an invalid config file$/) do
  prepare_config_directory
  config_file = File.expand_path(File.dirname(__FILE__)+ '/../../test/fixtures/config/malformed.json')
  FileUtils.cp(config_file, default_config_file)
end

Given(/^I don't have a config file$/) do
  FileUtils.rm_rf default_config_file
end

def default_config_file
  "#{ENV['HOME']}/.mole/config.json"
end

def prepare_config_directory
  FileUtils.mkdir_p("#{ENV['HOME']}/.mole")
end
