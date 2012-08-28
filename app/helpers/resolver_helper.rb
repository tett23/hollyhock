#encoding: utf-8

Hollyhock.helpers do
  def page_names(uri)
    pathes = uri.split('/').delete_if{|s| s == ''}
    pathes.shift
    pathes.unshift('/')

    pathes
  end
end
