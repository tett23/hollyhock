#encoding: utf-8

class ApplicationConfig
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String, :required=>true, :unique=>true, :unique_index=>true, :messages=>{
    :is_unique=>"値はすでに使われています"
  }
  property :value, Text

  validates_is_unique :name, :scope=>:value

  def self.value(name)
    config = first(:name=>name)

    return nil if config.nil?

    config.value
  end
end
