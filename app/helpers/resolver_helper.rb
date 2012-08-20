#encoding: utf-8

Hollyhock.helpers do
  def page_names(uri)
    uri.split('/').delete_if{|s| s == ''}
  end
end
