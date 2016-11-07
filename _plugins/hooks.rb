Jekyll::Hooks.register :site, :post_read do |site|
  # Initialise the link register
  site.data['link-register'] = LinkList::LinkRegister.new
  # Build role structures
  site.data['role-icons'] = Roles::RoleIcons.new(site.data['roles'])
  site.data['role-map'] = Roles::RoleMap.new(site.data['roles'])
  site.data['git'] = NTHP::GitData.new
end

Jekyll::Hooks.register :site, :pre_render do |site|
  Jekyll.logger.info "Processing year graph..."
  site.data['year-graph'] = NTHP::YearGraph.new(site)
  site.data['renderonce-year-graph'] = NTHP::RenderOnce.new(site,
    'svg/year-graph.html')

  Jekyll.logger.info "Reticulating splines..."

  Jekyll.logger.info "Building people index..."
  site.data['people-index'] = PeopleIndex::PeopleIndex.new(site.collections["people"].docs)

  Jekyll.logger.info "Rendering site..."
end

Jekyll::Hooks.register :site, :post_write do |site|
  Jekyll.logger.info "Site written to disk"
end
