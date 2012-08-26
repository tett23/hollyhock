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

    page_names.reverse.unshift('<a href="/novels">novels</a>').unshift('<a href="/">donuthole.org</a>').join('&nbsp;/&nbsp;')
  end

  def breadcrumb(page)
    '<a href="'+get_href(page)+'">'+page.title+'</a>'
  end

  def get_href(page)
    slugs = _get_slug(page, [])
    '/novels/'+slugs.join('/')
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

  def create_template(static_page)
    template = StaticPage.get(static_page.template_id)

    if template.nil?
      p parse_textile(static_page.body)
      return render :haml, parse_textile(static_page.body), :layout=>'application'
    else
      page = template.body
      page.gsub!(/=yield/, parse_textile(static_page.body))
      return render :erb, page, :layout=>false
    end
  end

  def parse_textile(str)
    is_inline_script = false

    RedCloth.new(str).to_html.split("\n").map do |line|
      if line =~ /<\/?inline_script>/
        is_inline_script = !is_inline_script
      end

      line.gsub!(/^\s+/, '') unless is_inline_script

      line
    end.join("\n")
  end
end
