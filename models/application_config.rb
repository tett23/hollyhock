class ApplicationConfig
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :value, Text

  def self.value(name)
    config = first(:name=>name)

    return nil if config.nil?

    config.value
  end
end
