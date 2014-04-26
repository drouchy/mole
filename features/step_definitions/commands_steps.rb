When(/^I run mole with 'environments'$/) do
  command = File.expand_path(File.dirname(__FILE__)+ '/../../_build/mole')
  step("I run `#{command} environments`")
end

Then(/^the output should contain$/) do |string|
  step("the output should contain \"#{string}\"")
end