class HelpRequestsController < ApplicationController
  before_action :check_if_student!, only: [:destroy, :edit, :update, :create, :new]
  before_action :set_help_request, only: [:edit, :update, :destroy, :finish]


  # GET /help_requests
  # GET /help_requests.json
  def index
    @help_requests = current_user.help_requests.all
  end

  # GET /help_requests/1
  # GET /help_requests/1.json
  def show
    if current_user.tutor?
      @help_request = HelpRequest.find(params[:id])
    else
      @help_request = current_user.help_requests.find(params[:id])
      @offers = @help_request.offers
    end
  end

  def accept
    @help_request = HelpRequest.find(params[:id])
    if @help_request.state == "pending"
      @help_request.update(tutor_id: current_user.id, state: 1)
      @help_request.offers.update_all(state: 2)
      redirect_to chat_for_redirect
    else
      redirect_to @help_request
    end
  end

  def finish
    if current_user.student?
      @help_request.update(state: 2) if @help_request.state == "in_progress"
      redirect_to current_request_path
    else
      redirect_to @root_path
     end
  end

  # GET /help_requests/new
  def new
    @help_request = current_user.help_requests.new
  end

  # GET /help_requests/1/edit
  def edit
  end

  # POST /help_requests
  # POST /help_requests.json
  def create
    @help_request = current_user.help_requests.new(help_request_params)

    respond_to do |format|
      if @help_request.save
        format.html { redirect_to current_request_path, notice: 'Help request was successfully created.' }
        format.json { render :show, status: :created, location: @help_request }
      else
        format.html { render :new }
        format.json { render json: @help_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /help_requests/1
  # PATCH/PUT /help_requests/1.json
  def update
    respond_to do |format|
      if @help_request.update(help_request_params)
        format.html { redirect_to @help_request, notice: 'Help request was successfully updated.' }
        format.json { render :show, status: :ok, location: @help_request }
      else
        format.html { render :edit }
        format.json { render json: @help_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /help_requests/1
  # DELETE /help_requests/1.json
  def destroy
    @help_request.destroy
    respond_to do |format|
      format.html { redirect_to help_requests_url, notice: 'Help request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def chat_for_redirect
      Chat.where(chat_params).first || Chat.create(chat_params)
    end

    def chat_params
      {
        student_id: @help_request.student_id,
        tutor_id: current_user.id
      }
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_help_request
      @help_request = current_user.help_requests.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def help_request_params
      params.require(:help_request).permit(:description, :subject_id, :price, :problem_picture)
    end

    def check_if_student!
      redirect_to root_path unless current_user.student?
    end

end
