class Hollyhock < Padrino::Application
  register SassInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions


  get :':page', /^(^\/).+$/ do
    pathes = page_names(env['PATH_INFO'])
    @page = Page.path_resolver(pathes)

    halt 404 if @page.nil?

    @page.increment_view_count()

    render :'pages/show'
  end

  get :'/', /^(^\/)$/ do
    @collections = Page.root_collections()

    render :'pages/index'
  end

  error 404 do
    render 'errors/404'
  end

  error 505 do
    render 'errors/505'
  end
end
