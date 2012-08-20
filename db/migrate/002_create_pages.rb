migration 2, :create_pages do
  up do
    create_table :pages do
      column :id, Integer, :serial => true
      column :title, String, :length => 255
      column :slug, String, :length => 255
      column :description, Text
      column :body, Text
      column :parent_collection, Integer
      column :is_collection, Boolean
      column :view_count, Integer
    end
  end

  down do
    drop_table :pages
  end
end
