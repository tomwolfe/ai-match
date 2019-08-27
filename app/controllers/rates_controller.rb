class RatesController < ApplicationController
  before_action :set_rate, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:new, :create, :update]
  before_action :login_required, only: [:show, :new, :edit, :raters, :ratings, :mutual]
  before_action :user_owner, only: [:edit, :update, :destroy]
  before_action :view_rating, only: [:show]
  before_action :set_age, only: [:raters, :ratings, :mutual]
  
  
  # GET /raters
  def raters
    @raters = current_user.raters.where(value: true).where.not(rater_id: current_user.ratings.select(:user_id)).includes(:rater)
    @raters=User.handle_minors(@raters, current_user, true)
    #@raters = User.where(id: @user.raters.where(value: true).where.not(user_id: @user.ratings.select(:user_id)).select(:rater_id) ).near(current_user)
    #@raters=User.near(current_user).joins(:raters).preload(:raters).where("raters.value" => true).where.not(user_id: current_user.ratings.select(:user_id))
  end
  
  # GET /ratings
  def ratings
    @ratings = current_user.ratings.includes(:user)
    @ratings =User.handle_minors(@ratings, current_user, true)
    #@ratings = User.near(current_user).joins(:ratings).preload(:ratings)
  end
  
   # GET /mutual
  def mutual
    @ratings = current_user.ratings.where(value: true).joins("INNER JOIN Rates r2 ON Rates.user_id=r2.rater_id AND Rates.rater_id=r2.user_id").where(rater_id: current_user.id).includes(:user)
    @ratings=User.handle_minors(@ratings, current_user, true)
    #@ratings = User.near(current_user).joins(:ratings).preload(:ratings)
  end

  # GET /rates/1
  # GET /rates/1.json
  def show
  end

  # GET /:user_id/rates/new
  def new
    @rate = Rate.new
  end

  # GET /rates/1/edit
  def edit
  end

  # POST /:user_id/rates
  # POST /:user_id/rates.json
  def create
    @rate = @user.raters.new(rate_params)
    @rate.rater_id = current_user.id

    respond_to do |format|
      if @rate.save
        format.html { redirect_to @rate, notice: 'Rate was successfully created.' }
        format.json { render :show, status: :created, location: @rating }
      else
        format.html { render :new }
        format.json { render json: @rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rates
  def update
    respond_to do |format|
      if @rate.update(rate_params)
        format.html { redirect_to @rate, notice: 'Rate was successfully updated.' }
        format.json { render :show, status: :ok, location: @rate }
      else
        format.html { render :edit }
        format.json { render json: @rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rates
  def destroy
    @rate.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Rate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rate
      @rate = Rate.find(params[:id])
    end
    
    def set_user
      @user = User.find(params[:user_id])
    end

    def user_owner
      unless @rate.rater_id == current_user.id
        flash[:notice] = 'Access denied as you are not the owner of this Rate'
        redirect_to :back
      end
    end
    
    def view_rating
      unless @rate.rater_id == current_user.id || @rate.user_id == current_user.id
        flash[:notice] = 'Access denied as you are neither the owner or receiver of this Rate'
        redirect_to :back
      end
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def rate_params
      params.require(:rate).permit(:user_id, :rater_id, :value)
    end
end
