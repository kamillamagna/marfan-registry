class DiagnosesController < ApplicationController
  before_action :set_diagnosis, only: [:show, :edit, :update, :destroy]

  def new
    @diagnosis = Diagnosis.new
  end

  def create
    @diagnosis = Diagnosis.new(diagnosis_params)
    if @diagnosis.save
      flash[:success] = "#{@diagnosis.note} of #{find_trail(Topic.find(@diagnosis.topic_id))} added to visit"
      redirect_to edit_visit_path(@diagnosis.visit_id)
    else
      flash[:error] = "Please re-check information: #{@diagnosis.errors.full_messages}"
      Rails.logger.info(@diagnosis.errors.inspect)
      render :back
    end
  end

  def index
    @diagnoses = Diagnosis.all
  end

  def show
  end

  def edit
  end

  def update
    if @diagnosis.update(diagnosis_params)
      flash[:success] = "#{@diagnosis.note} of #{find_trail(Topic.find(@diagnosis.topic_id))} added to visit"
      redirect_to edit_visit_path(@diagnosis.visit_id)
    else
      flash[:error]
      render json: @diagnosis.errors, status: :unprocessable_entity
      redirect_to edit_visit_path(@diagnosis.visit_id)
    end
  end

  def destroy
    Diagnosis.find(params[:id]).destroy
    redirect_to :back
  end

  private

  def set_diagnosis
    @diagnosis = Diagnosis.find(params[:id])
  end

  def diagnosis_params
    params.permit(
      :topic_id,
      :patient_id,
      :time_ago,
      :time_ago_scale,
      :absolute_start_date,
      :visit_id,
      :note
    )
  end
end