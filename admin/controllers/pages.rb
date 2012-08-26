Admin.controllers :pages do

  get :index do
    @pages = Page.all
    render 'pages/index'
  end

  get :new do
    @page = Page.new
    @page.page_id = ApplicationConfig.value(:novels_root)
    @collections = Page.collections()
    render 'pages/new'
  end

  post :create do
    @page = Page.new(params[:page])
    @collections = Page.collections()
    if @page.save
      flash[:notice] = 'Page was successfully created.'
      redirect url(:pages, :edit, :id => @page.id)
    else
      render 'pages/new'
    end
  end

  get :edit, :with => :id do
    @page = Page.get(params[:id])
    @collections = Page.collections()
    render 'pages/edit'
  end

  put :update, :with => :id do
    @page = Page.get(params[:id])
    params[:page][:page_id] = nil if params[:page][:page_id] == ''
    novels_root_id = ApplicationConfig.value(:novels_root).to_i
    params[:page][:page_id] = novels_root_id if @page.page_id.nil? && (@page.id != novels_root_id)

    @collections = Page.collections()

    if @page.update(params[:page])
      flash[:notice] = 'Page was successfully updated.'
      redirect url(:pages, :edit, :id => @page.id)
    else
      render 'pages/edit'
    end
  end

  delete :destroy, :with => :id do
    page = Page.get(params[:id])
    if page.destroy
      flash[:notice] = 'Page was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy Page!'
    end
    redirect url(:pages, :index)
  end
end
