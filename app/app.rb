class Hollyhock < Padrino::Application
  register SassInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Cache

  enable :sessions

  get :'/feed', :provides => [:rss2] do
    @posts = Feed.contents

    case content_type
    when :rss
      render :builder, :'root/rss2', :layout=>false
    when :atom
      render :builder, :'root/atom', :layout=>false
    end
  end

  get :'/:path', /^.+$/ do
    path = env['PATH_INFO']
    @content = StaticPage.find_by_path(path)

    pathes = page_names(path)
    @content ||= Page.path_resolver(pathes)

    halt 404 if @content.nil?
    @title = @content.title

    if @content.class == Page
      halt 404 unless @content.is_public

      @content.increment_view_count()
      return render :'pages/show', :layout=>:novel
    else
      return create_template(@content)
    end
  end

  error 404 do
    render 'errors/404'
  end

  error 505 do
    render 'errors/505'
  end
end
