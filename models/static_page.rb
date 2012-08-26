class StaticPage
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :title, String
  property :route, String
  property :body, Text
  property :is_template, Boolean
  property :is_article, Boolean
  property :template_id, Integer, :required=>false
  property :created_at, DateTime
  property :updated_at, DateTime

  def self.find_by_path(path)
    first(:route=>path)
  end

  def self.collections
    all(:is_template=>true).map do |r|
      [r.title, r.id]
    end
  end

  def self.articles
    all(:is_article=>true)
  end
end
