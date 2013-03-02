author_name = get_config(:author)
site_url = get_config(:site_url)

xml.instruct!
xml.rss(
  "version"    => "2.0",
  "xmlns:dc"   => "http://purl.org/dc/elements/1.1/",
  "xmlns:atom" => "http://www.w3.org/2005/Atom"
) do
  xml.channel do
    xml.title         get_config(:site_name)
    xml.link          site_url
    xml.lastBuildDate Time.now.rfc822
    xml.description   site_description
    xml.atom :link, "href" => site_url+'/feed.rss', "rel" => "self", "type" => "application/rss+xml"

    @posts.each do |post|
      href = (post.class == StaticPage ? post.route : post.href)

      xml.item do
        xml.title        post.title
        xml.link         href
        xml.guid         site_url+href
        xml.description  post.body
        xml.pubDate      post.created_at.nil? ? '' : post.created_at.rfc822
        xml.dc :creator, author_name
      end
    end
  end
end
