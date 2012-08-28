task :page_publish_on do
  Page.all(:publish_on.gte=>Time.now, :is_public=>false).each do |page|
    page.update(:is_public=>true)
  end
end
