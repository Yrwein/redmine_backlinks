
module RedmineBacklinks
  def self.get(page)
    project = page.project

    results_all_projects, = WikiPage.search(
      [
        "[[#{project.identifier}:#{page.title}]]",
        "[[#{project.identifier}:#{page.title}|",
        "[[#{project.name}:#{page.title}]]",
        "[[#{project.name}:#{page.title}|",
      ],
      nil, # all projects
      :titles_only => false
    )
    results_current_project, = WikiPage.search(
      ["[[#{page.title}]]", "[[#{page.title}|"],
      project,
      :titles_only => false
    )
    results = results_all_projects + results_current_project

    # don't show links to self
    results = results.reject do |backlink_page|
      backlink_page.id == page.id
    end
  end
end
