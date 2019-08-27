class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :user_owner, only: [:edit, :update, :destroy]
  before_action :login_required, only: [:show, :index, :edit]
  before_action :set_age, only: [:index]
  
  #def new
    #@user=User.create_with_omniauth(session[:omniauth])
  #end
  
  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = user.id
      session[:omniauth] = nil
      redirect_to @user, :notice => "Signed in."
    else
      render :new
    end
  end

  # GET /users
  # GET /users.json
  def index
    if params[:distance].present?
      @users=User.near(current_user, params[:distance])
    else
      @users=User.near(current_user, 100)
    end
    @users=@users.where.not(id: current_user.ratings.select(:user_id))
    @users=User.handle_minors(@users, current_user)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if (current_user.id == @user.id) || (current_user.age >= 18 && @user.age >=18) || (current_user.age < 18 && @user.age <18)
      render :show
    else
      redirect_to :root, notice: "One of you is over 18 and one is under. Cannot show user."
    end
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    session[:user_id] = nil
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if params[:id]
        @user = User.find(params[:id])
      else
        @user = User.find(params[:user_id])
      end
    end
    
    def user_owner
      unless @user.id == current_user.id
        flash[:notice] = 'Access denied as you are not the owner of this User'
        redirect_to :back
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :age, :location, :email, :height, :weight, :about, :orientation, :sex,)
    end
end
