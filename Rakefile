# frozen_string_literal: true

require_relative 'environment'

task default: :test

task :test do
  require_relative 'test/test_helper'

  Dir.glob('test/**/*.rb') { |f| require_relative(f) }
end
