Admin.controllers :articles do

  get :index do
    @static_pages = StaticPage.articles
    render 'articles/index'
  end

  get :new do
    @static_page = StaticPage.new
    render 'articles/new'
  end

  post :create do
    @static_page = StaticPage.new(params[:static_page])

    if @static_page.save
      @static_page.update(:route=>'/articles/'+@static_page.id.to_s)
      flash[:notice] = 'StaticPage was successfully created.'
      redirect url(:articles, :edit, :id => @static_page.id)
    else
      render 'articles/new'
    end
  end

  get :edit, :with => :id do
    @static_page = StaticPage.get(params[:id])
    render 'articles/edit'
  end

  put :update, :with => :id do
    @static_page = StaticPage.get(params[:id])
    if @static_page.update(params[:static_page])
      @static_page.update(:route=>'/articles/'+@static_page.id.to_s)
      flash[:notice] = 'StaticPage was successfully updated.'
      redirect url(:articles, :edit, :id => @static_page.id)
    else
      render 'articles/edit'
    end
  end

  delete :destroy, :with => :id do
    static_page = StaticPage.get(params[:id])
    if static_page.destroy
      flash[:notice] = 'StaticPage was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy StaticPage!'
    end
    redirect url(:articles, :index)
  end
end
