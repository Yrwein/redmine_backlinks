
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

    all_projects_search_begin = "[[" + page.project.identifier + ":" + page.title;
    results_all_projects, = WikiPage.search(
      [all_projects_search_begin + "]]", all_projects_search_begin + "|"],
      nil, # all projects
      :titles_only => false
    )
    results_current_project, = WikiPage.search(
      ["[[" + page.title + "]]", "[[" + page.title + "|"],
      @project,
      :titles_only => false
    )
    results = results_all_projects + results_current_project

    # don't show links to self
    results = results.reject do |page|
      page.id == obj.id
    end

    links = results.map do |page|
      title = page.pretty_title
      title = page.project.name + ": " + title if page.project != @project
      url_params = { :controller => 'wiki', :action => 'show', :project_id => page.project, :id => page.title }
      link_to title, url_params
    end

    if links.empty?
      content = "No backlinks"
    else
      content = "Backlinks: <ul><li>" + links.join("</li><li>") + "</li></ul>"
    end
    content.html_safe
  end
end
