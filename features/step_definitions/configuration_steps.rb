require 'fileutils'

Given(/^I have a regular config file$/) do
  config_file = File.expand_path(File.dirname(__FILE__)+ '/../../test/fixtures/config/regular.json')
  FileUtils.mkdir_p("#{ENV['HOME']}/.mole")
  FileUtils.cp(config_file, "#{ENV['HOME']}/.mole/config.json")
end
