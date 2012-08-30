Admin.controllers :static_pages do

  get :index do
    @static_pages = StaticPage.pages
    render 'static_pages/index'
  end

  get :new do
    @static_page = StaticPage.new
    @collections = StaticPage.collections()
    render 'static_pages/new'
  end

  post :create do
    params[:static_page][:template_id] = nil if params[:static_page][:template_id] == ''
    p params
    @static_page = StaticPage.new(params[:static_page])
    @collections = StaticPage.collections()
    if @static_page.save
      flash[:notice] = 'StaticPage was successfully created.'
      redirect url(:static_pages, :edit, :id => @static_page.id)
    else
      render 'static_pages/new'
    end
  end

  get :edit, :with => :id do
    @static_page = StaticPage.get(params[:id])
    @collections = StaticPage.collections()
    render 'static_pages/edit'
  end

  put :update, :with => :id do
    params[:static_page][:template_id] = nil if params[:static_page][:template_id] == ''
    @static_page = StaticPage.get(params[:id])
    @collections = StaticPage.collections()
    if @static_page.update(params[:static_page])
      flash[:notice] = 'StaticPage was successfully updated.'
      redirect url(:static_pages, :edit, :id => @static_page.id)
    else
      render 'static_pages/edit'
    end
  end

  delete :destroy, :with => :id do
    static_page = StaticPage.get(params[:id])
    if static_page.destroy
      flash[:notice] = 'StaticPage was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy StaticPage!'
    end
    redirect url(:static_pages, :index)
  end
end
