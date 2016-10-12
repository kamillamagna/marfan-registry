class HospitalizationsController < ApplicationController
  def index
    @hospitalizations = Hospitalization.all
  end

  def new
    @hospitalization = Hospitalization.find(params[:id])
  end

  def create
    @hospitalization = Hospitalization.new(hospitalization_params)

    if @hospitalization.save
      render json: @hospitalization
    else
      render json: @hospitalization.errors, status: :unprocessable_entity
    end
  end

  def update
    if @hospitalization.update(hospitalization_params)
      render json: @hospitalization
    else
      render json: @hospitalization.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @hospitalization.destroy
    head :no_content
  end

  private

  def hospitalization_params
    params.require(:hospitalization).permit(
    :visit_id,
    :admission_date,
    :length_of_stay,
    :type,
    :description,
    :location)
  end

  def current_hospitalization
    @hospitalization = hospitalization.find(params[:id])
  end
end