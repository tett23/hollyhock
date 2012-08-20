#encoding: utf-8

Hollyhock.helpers do
  def breadcrumbs(page)
    return '' if page.nil?

    page_names = []
    page_names << breadcrumb(page)
    parent = nil

    loop  do
      parent = page.page
      page = parent
      break if parent.nil?

      page_names << breadcrumb(parent)
    end

    page_names.reverse.unshift('<a href="/">novels</a>').join('&nbsp;/&nbsp;')
  end

  def breadcrumb(page)
    '<a href="'+get_href(page)+'">'+page.title+'</a>'
  end

  def get_href(page)
    slugs = _get_slug(page, [])
    '/'+slugs.join('/')
  end

  def _get_slug(page, arr)
    _arr = []
    _arr << (page.slug.blank? ? page.title : page.slug)

    return _arr+arr if page.page.nil?

    _get_slug(page.page, _arr) + arr
  end

  def formated_time(datetime)
    datetime.strftime('%y%m%d(%a)&nbsp;%H:%M:%S') rescue ''
  end
end
