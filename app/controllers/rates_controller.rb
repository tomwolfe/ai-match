class RatesController < ApplicationController
  before_action :set_rate_user, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:new, :create, :update]
  before_action :login_required, only: [:show, :new, :edit]
  before_action :user_owner, only: [:edit, :update, :destroy]
  before_action :view_rating, only: [:show]

  # GET /:user_id/rates/1
  # GET /:user_id/rates/1.json
  def show
  end

  # GET /:user_id/rates/new
  def new
    @rate = Rate.new
  end

  # GET /:user_id/rates/1/edit
  def edit
  end

  # POST /:user_id/rates
  # POST /:user_id/rates.json
  def create
    @rate = @user.raters.new(rate_params)
    @rate.rater_id = current_user.id

    respond_to do |format|
      if @rate.save
        format.html { redirect_to [@user, @rate], notice: 'Rate was successfully created.' }
        format.json { render :show, status: :created, location: @rating }
      else
        format.html { render :new }
        format.json { render json: @rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /:user_id/rates
  def update
    respond_to do |format|
      if @rate.update(rate_params)
        format.html { redirect_to [@user, @rate], notice: 'Rate was successfully updated.' }
        format.json { render :show, status: :ok, location: @rate }
      else
        format.html { render :edit }
        format.json { render json: @rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /:user_id/rates
  def destroy
    @rate.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Rate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rate_user
      @rate = Rate.find(params[:id])
      @user = User.find(params[:user_id])
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
