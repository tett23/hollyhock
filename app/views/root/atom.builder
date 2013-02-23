author_name = get_config(:author)
site_url = get_config(:site_url)

xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title   get_config(:site_name)
  xml.link    "rel" => "self", "href" => site_url
  xml.id      site_url
  xml.updated @posts.first.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ"
  xml.author  { xml.name author_name }

  @posts.each do |post|
    xml.entry do
      xml.title   post.title
      xml.link    "rel" => "alternate", "href" => (post.class == StaticPage ? post.route : post.href)
      xml.id      site_url+(post.class == StaticPage ? post.route : post.href)
      xml.updated post.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ"
      xml.author  { xml.name author_name}
      xml.summary post.body
    end
  end
end
