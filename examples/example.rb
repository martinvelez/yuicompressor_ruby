#!/usr/bin/env ruby

require 'yuicompressor'

input = ARGF.read
# Assuming engine is installed in this gem's "ext" folder.
# Otherwise, you must pass the engine's executable path to the class's 
# constructor.
# For example:
# engine = YUICompressor.new({:engine => "/path/to/engine"})
engine = YUICompressor.new

output, errors, status = engine.obfuscate(input)

puts "STATUS:", status
puts "ERRORS: ", errors
puts "OUTPUT:", output
