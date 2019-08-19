class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :raters, :ratings]
  before_action :user_owner, only: [:edit, :update, :destroy, :raters, :ratings]
  
  # GET /users/:user_id/raters
  def raters
    @raters = @user.raters.where(value: true).where.not(user_id: @user.ratings.select(:rater_id)).includes(:rater)
    #@raters = User.where(id: @user.raters.where(value: true).where.not(user_id: @user.ratings.select(:user_id)).select(:rater_id) ).near(current_user)
    #@raters=User.near(current_user).joins(:raters).preload(:raters).where("raters.value" => true).where.not(user_id: current_user.ratings.select(:user_id))
  end
  
  # GET /users/:user_id/ratings
  def ratings
    @ratings = @user.ratings.includes(:user)
    #@ratings = User.near(current_user).joins(:ratings).preload(:ratings)
  end
  
  def new
    @user=User.build_with_omniauth(session[:omniauth])
  end
  
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
    @users=User.handle_minors(@users, current_user)
  end

  # GET /users/1
  # GET /users/1.json
  def show
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
        flash[:notice] = 'Access denied as you are not owner of this User'
        redirect_to users_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :age, :location, :email, :height, :weight, :about, :orientation, :sex,)
    end
end
