class RatesController < ApplicationController
  before_action :set_rate_user, only: [:show, :edit, :update, :destroy]

  # GET /:user_id/rates/1
  # GET /:user_id/rates/1.json
  def show
  end

  # GET /:user_id/rates/new
  def new
    @user=User.find(params[:user_id])
    @rate = @user.ratings.new(user_id: current_user.id)
  end

  # GET /:user_id/rates/1/edit
  def edit
  end

  # POST /:user_id/rates
  # POST /:user_id/rates.json
  def create
    @rate = Rate.new(rate_params)

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

  # PATCH/PUT /:user_id/rates
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

  # DELETE /ratings/1
  # DELETE /ratings/1.json
  def destroy
    @rate.destroy
    respond_to do |format|
      format.html { redirect_to rates_url, notice: 'Rate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rate_user
      @rate = Rate.find(params[:id])
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rate_params
      params.require(:rate).permit(:user_id, :rater_id, :value)
    end
end
