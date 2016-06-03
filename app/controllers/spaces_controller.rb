class SpacesController < ApplicationController
  before_action :set_space, only: [:show, :edit, :update]
  before_action :authenticate_user!, except: [:show]
  before_action :save_my_previous_url, only: [:show]

  def index
    @spaces = current_user.spaces
  end

  def show
    @photos = @space.photos

    @booked = Booking.where("space_id = ? AND user_id = ?", @space.id, current_user.id).present? if current_user

    @reviews = @space.reviews
    @hasReview = @reviews.find_by(user_id: current_user.id) if current_user
  end

  def new
    @space = current_user.spaces.build
  end

  def create
    @space = current_user.spaces.build(space_params)

    if @space.save

      if params[:images]
        params[:images].each do |image|
          @space.photos.create(image: image)
        end
      end

      @photos = @space.photos
      redirect_to edit_space_path(@space), notice: "Saved..."
    else
      flash[:error] = @space.errors.full_messages.join('. ')
      render :new
    end
  end

  def edit
    if current_user.id == @space.user.id
      @photos = @space.photos
    else
      redirect_to root_path, notice: "You don't have permission."
    end
  end

  def update
    if @space.update(space_params)

      if params[:images]
        params[:images].each do |image|
          @space.photos.create(image: image)
        end
      end

      redirect_to edit_space_path(@space), notice: "Updated..."
    else
      flash[:error] = @space.errors.full_messages.join('. ')
      render :edit
    end
  end

  private
    def set_space
      #@space = Space.find(params[:id])
      @space = Space.find_by(id: params[:id])
      if @space == nil
        #flash[:error] = "This space dont't exist or isn't active anymore."
        redirect_to save_my_previous_url, alert: "This space dont't exist or isn't active anymore."
      end
    end

    def space_params
      params.require(:space).permit(:space_type,:accomodation_type,:capacity,:space_name,:summary,:address,:is_air,:is_heating,:is_bar,:is_bathroom,:is_projector,:is_sound_system,:is_stage,:is_podium,:is_wifi,:is_catering,:price,:active)
    end

    def save_my_previous_url
      # session[:previous_url] is a Rails built-in variable to save last url.
      session[:my_previous_url] = URI(request.referer || '').path
    end
end
