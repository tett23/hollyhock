Admin.controllers :application_configs do

  get :index do
    @application_configs = ApplicationConfig.all
    render 'application_configs/index'
  end

  get :new do
    @application_config = ApplicationConfig.new
    render 'application_configs/new'
  end

  post :create do
    @application_config = ApplicationConfig.new(params[:application_config])
    if @application_config.save
      flash[:notice] = 'ApplicationConfig was successfully created.'
      redirect url(:application_configs, :edit, :id => @application_config.id)
    else
      render 'application_configs/new'
    end
  end

  get :edit, :with => :id do
    @application_config = ApplicationConfig.get(params[:id])
    render 'application_configs/edit'
  end

  put :update, :with => :id do
    @application_config = ApplicationConfig.get(params[:id])
    if @application_config.update(params[:application_config])
      flash[:notice] = 'ApplicationConfig was successfully updated.'
      redirect url(:application_configs, :edit, :id => @application_config.id)
    else
      render 'application_configs/edit'
    end
  end

  delete :destroy, :with => :id do
    application_config = ApplicationConfig.get(params[:id])
    if application_config.destroy
      flash[:notice] = 'ApplicationConfig was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy ApplicationConfig!'
    end
    redirect url(:application_configs, :index)
  end
end
