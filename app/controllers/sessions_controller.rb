class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    @user = User.find_by_provider_and_uid(auth["provider"], auth["uid"])
    if @user
      session[:user_id] = @user.id
      redirect_to @user, :notice => "Signed in!"
    else
      @user=User.create_with_omniauth(auth)
      if @user.save
        session[:user_id] = @user.id
        redirect_to edit_user_path(@user), :notice => "Signed in! Set your age to continue."
      #else
        #session[:omniauth] = auth
        #redirect_to new_user_url
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
end
