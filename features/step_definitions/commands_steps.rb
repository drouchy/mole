When(/^I run mole with no argument$/) do
  step("I run `#{command}`")
end

When(/^I run mole with an invalid command$/) do
  step("I run `#{command} invalid_command`")
end

When(/^I run mole with 'environments'$/) do
  step("I run `#{command} environments`")
end

When(/^I run mole with 'help'$/) do
  step("I run `#{command} help`")
end

Then(/^the output should contain$/) do |string|
  step("the output should contain \"#{string}\"")
end

Then(/^the output should contain the usage test$/) do
  step("the output should contain \"#{usage_text}\"")
end

def command
  File.expand_path(File.dirname(__FILE__)+ '/../../_build/mole')
end


def usage_text
<<-eof
  usage: mole command [<args>]

  Basic commands:
    environments   manage environments in the config file

  Remote command:
    log            tail the logs on the remote servers

eof
end
