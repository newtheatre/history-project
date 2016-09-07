Jekyll::Hooks.register :site, :pre_render do |site|
  Jekyll.logger.info "Rendering site..."
end

Jekyll::Hooks.register :site, :post_read do |site|
  # Initialise the link register
  site.data['link-register'] = LinkList::LinkRegister.new
end

Jekyll::Hooks.register :site, :post_write do |site|
  Jekyll.logger.info "Site written to disk"
end
