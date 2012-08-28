#encoding: utf-8

Hollyhock.helpers do
  def breadcrumbs(page)
    return '' if page.nil?

    page_names = []
    page_names << breadcrumb(page)
    parent = nil

    100.times do
      parent = page.page
      break if parent.nil?
      page = parent

      page_names << breadcrumb(parent)
    end

    page_names.reverse.unshift('<a href="/">donuthole.org</a>').join('&nbsp;/&nbsp;')
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

  def create_template(static_page)
    template = StaticPage.get(static_page.template_id)

    if template.nil?
      return render :haml, textile(static_page.body), :layout=>'application'
    else
      return render :haml, template.body, :layout=>:application do
        textile static_page.body
      end
    end
  end

  def textile(str)
    is_inline_script = false

    RedCloth.new(str).to_html.split("\n").map do |line|
      if line =~ /<inline_script>/
        is_inline_script = true
      elsif line =~ /<\/inline_script>/
        is_inline_script = false
      end

      line.gsub!(/^\s+/, '') unless is_inline_script

      line
    end.join("\n")
  end
end
