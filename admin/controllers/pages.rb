Admin.controllers :pages do

  get :index do
    @pages = Page.all
    render 'pages/index'
  end

  get :new do
    @page = Page.new
    @collections = Page.collections()
    render 'pages/new'
  end

  post :create do
    @page = Page.new(params[:page])
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
