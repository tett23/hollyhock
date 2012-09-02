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

    page_names.reverse.unshift('<a href="/">'+site_name+'</a>').join('&nbsp;/&nbsp;')
  end

  def site_name
    site_name = ApplicationConfig.value(:site_name)
  end

  def breadcrumb(page)
    '<a href="'+page.href+'">'+page.title+'</a>'
  end

  def formated_time(datetime)
    datetime.strftime('%y%m%d(%a)&nbsp;%H:%M:%S') rescue ''
  end

  def create_template(content)
    template = StaticPage.get(content.template_id)

    if template.nil?
      return render :haml, textile(content.body), :layout=>'application'
    else
      return render :haml, template.body, :layout=>:application do
        textile content.body
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
