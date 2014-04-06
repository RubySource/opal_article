require 'opal'
require 'opal-jquery'

desc "Build our app to build.js"
task :build do
  env = Opal::Environment.new
  env.append_path "app"

  File.open("conway.js", "w+") do |out|
    out << env["conway"].to_s
  end
end
