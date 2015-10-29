Jekyll::Hooks.register :site, :pre_render do |site|
  puts "Rendering site..."
end

Jekyll::Hooks.register :site, :post_write do |site|
  puts "Site written to disk"
end
