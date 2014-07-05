require 'aruba/cucumber'

Before do
  build_app

  @original_home = ENV['HOME']
  home = File.expand_path(File.dirname(__FILE__)+ '/../../tmp/fake_home')
  ENV['HOME'] = home
  FileUtils.rm_rf home
  FileUtils.mkdir home
end

After do
  ENV['HOME']    = @original_home
end

def build_app
  $built ||= false
  unless $built
    `mix escriptize`
    $built = true
  end
end