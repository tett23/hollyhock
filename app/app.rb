class Hollyhock < Padrino::Application
  register SassInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions


  get :'/novels/:page', /^(^\/)novels($|(?=\/).+$)/ do
    pathes = page_names(env['PATH_INFO'])
    @page = Page.path_resolver(pathes)

    halt 404 if @page.nil?
    halt 404 unless @page.is_public

    @page.increment_view_count()

    render :'pages/show', :layout=>:novel
  end

  get :'/:static_page', /^(^\/).+$/ do
    path = env['PATH_INFO']
    @static_page = StaticPage.find_by_path(path)

    halt 404 if @static_page.nil?

    @title = @static_page.title

    create_template(@static_page)
  end

  get :'/', /^(^\/)$/ do
    @articles = StaticPage.articles()

    render :'root/index'
  end

  error 404 do
    render 'errors/404'
  end

  error 505 do
    render 'errors/505'
  end
end
