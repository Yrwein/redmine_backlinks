
require_dependency 'backlinks'

Redmine::Plugin.register :wiki_backlinks do
  name 'Backlinks plugin'
  author 'Josef Cech'
  description "
    Plugin providing backlinks macro for wiki pages.
    <a href='https://github.com/yrwein/redmine_backlinks'>Plugin page.</a>
  ".html_safe
  version '0.0.1'
end

Redmine::WikiFormatting::Macros.register do
  desc "Shows backlinks to the/a wiki page. Example:\n\n  !{{backlinks}}"
  macro :backlinks do |obj, args|
    if obj.is_a?(WikiContent) || obj.is_a?(WikiContent::Version)
      page = obj.page
    else
      raise 'With no argument, this macro can be called from wiki pages only.'
    end
    raise 'Page not found' if page.nil? || !User.current.allowed_to?(:view_wiki_pages, page.wiki.project)

    render :partial => 'wiki/backlinks', :locals => {:page => page}
  end
end
