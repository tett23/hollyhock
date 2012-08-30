#encoding: utf-8
class Page
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :title, String
  property :slug, String
  property :description, Text
  property :body, Text
  property :parent_collection, Integer, :required=>false
  property :is_collection, Boolean
  property :view_count, Integer, :default=>0
  property :page_id, Integer
  property :is_public, Boolean
  property :publish_on, DateTime
  property :created_at, DateTime
  property :updated_at, DateTime


  belongs_to :page
  has n, :pages, :order=>[:created_at.desc, :id.desc]

  def self.path_resolver(pathes)
    pages = [get(ApplicationConfig.value(:novels_root))]

    return pages.first if pathes.size == 1 && pathes.first == '/'
    pathes.shift

    pathes.each do |path|
      page = pages.last.pages.first(:slug=>path)
      page = pages.last.pages.first(:title=>URI.decode(path)) if page.nil?

      pages << page
    end

    pages.last
  end

  def self.root_collections
    all(:is_collection=>true, :page_id=>nil)
  end

  def self.collections
    all(:is_collection=>true).map do |r|
      [r.select_title, r.id]
    end
  end

  def increment_view_count
    view_count = self.view_count.nil? ? 1 : self.view_count+1
    update(:view_count=>view_count)
  end

  def select_title
    (self._select_title(self, [])).join('/')
  end

  def href
    slugs = _get_slug(self, [])
    '/'+slugs.join('/')
  end


  :private
  def _get_slug(page, arr)
    _arr = []
    _arr << (page.slug.blank? ? page.title : page.slug)

    return _arr+arr if page.page.nil?

    _get_slug(page.page, _arr) + arr
  end

  def _select_title(page, arr)
    _arr = []
    _arr << page.title

    return _arr+arr if page.page.nil?

    _select_title(page.page, _arr) + arr
  end
end
