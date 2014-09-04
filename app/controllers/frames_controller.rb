class FramesController < ApplicationController
  before_action :set_frame, only: [:show, :edit, :update, :destroy]

  # GET /frames
  # GET /frames.json
  def index
    @frames = Frame.all
    if params[:frame_number]
      session[:frame_number] = params[:frame_number]
    end
    if params[:player_id]
      session[:player_id] = params[:player_id]
    end
    @player = session[:player_id]
  end

  # GET /frames/1
  # GET /frames/1.json
  def show
  end

  # GET /frames/new
  def new
    @frame = Frame.new
  end

  # GET /frames/1/edit
  def edit
  end

  # POST /frames
  # POST /frames.json
  def create
    @frame = Frame.new(frame_params)
    @frame.try1 = 0
    @frame.try2 = 0
    @frame.total = 0
    @frame.game_id = session[:player_id]  
    @frame.completed = false
    @frame.number = 1

    respond_to do |format|
      if @frame.save
        format.html { redirect_to @frame, notice: 'Frame was successfully created.' }
        format.json { render action: 'show', status: :created, location: @frame }
      else
        format.html { render action: 'new' }
        format.json { render json: @frame.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /frames/1
  # PATCH/PUT /frames/1.json
  def update
    respond_to do |format|
      if @frame.update(frame_params)
        format.html { redirect_to @frame, notice: 'Frame was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @frame.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /frames/1
  # DELETE /frames/1.json
  def destroy
    @frame.destroy
    respond_to do |format|
      format.html { redirect_to frames_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_frame
      @frame = Frame.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def frame_params
      params.require(:frame).permit(:try1, :try2integer, :number)
    end
end
