#!/usr/bin/env ruby
result = `sass test.sass fgrid.css`
raise result unless $?.to_i == 0
raise "When compiled the module should output some CSS" unless File.exists?('fgrid.css')
puts "Regular compile worked successfully"
