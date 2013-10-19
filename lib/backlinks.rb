
module RedmineBacklinks
	def self.get(page)
		all_projects_search_begin = "[[" + page.project.identifier + ":" + page.title;
	    results_all_projects, = WikiPage.search(
	      [all_projects_search_begin + "]]", all_projects_search_begin + "|"],
	      nil, # all projects
	      :titles_only => false
	    )
	    results_current_project, = WikiPage.search(
	      ["[[" + page.title + "]]", "[[" + page.title + "|"],
	      page.project,
	      :titles_only => false
	    )
	    results = results_all_projects + results_current_project

	    # don't show links to self
	    results = results.reject do |backlink_page|
	      backlink_page.id == page.id
	    end
	end
end
