class PagesController < ApplicationController

  def main
    @spaces = Space.all
  end

  def admin
    if params[:admin].present?
      if params[:admin][:usr] == "innospace" && params[:admin][:pwd] == "1nn0sp4c3"
        redirect_to "/main"
      end
    end
  end

end
