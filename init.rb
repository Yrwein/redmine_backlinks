
require_dependency 'backlinks'

Redmine::Plugin.register :wiki_backlinks do
  name 'Backlinks plugin'
  author 'Josef Cech'
  description 'Plugin providing backlinks for wiki pages.'
  url 'https://github.com/yrwein/redmine_backlinks'
  version '0.0.1'
  settings :default => {'show_always' => true}, :partial => 'settings/backlinks_settings'
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

    render :partial => 'wiki/backlinks', :locals => {:page => page, :show_not_found_message => true}
  end
end
