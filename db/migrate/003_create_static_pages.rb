migration 3, :create_static_pages do
  up do
    create_table :static_pages do
      column :id, Integer, :serial => true
      column :route, String, :length => 255
      column :body, Text
      column :is_template, Boolean
      column :template_id, Integer
    end
  end

  down do
    drop_table :static_pages
  end
end
