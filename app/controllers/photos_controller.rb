class PhotosController < ApplicationController
  before_action :authenticate_user!, except: [:notify]

  def destroy
    @photo = Photo.find(params[:id])
    space = @photo.space

    @photo.destroy
    @photos = Photo.where(space_id: space.id)

    respond_to :js
  end
end
