class PagesController < ApplicationController

  def main
    @spaces = Space.all
  end

  def search
    if params[:search].present? && params[:search].strip != ""
      session[:loc_search] = params[:search]
    end

    arrResult = Array.new

    if session[:loc_search] && session[:loc_search] != ""
      @spaces_address = Space.where(active: true).near(session[:loc_search], 5, order: 'distance')
    else
      @spaces_address = Space.where(active: true).all
    end

    @search = @spaces_address.ransack(params[:q])
    @spaces = @search.result.includes(:bookings)

    @arrSpaces = @spaces.to_a

    if (params[:bookings_start_date] && params[:bookings_end_date] && !params[:bookings_start_date].empty? && !params[:bookings_end_date].empty?)

      start_date = Date.parse(params[:bookings_start_date])
      end_date = Date.parse(params[:bookings_end_date])

      @spaces.each do |space|

        not_available = space.bookings.where(
          "(? <= start_date AND start_date <= ?)
          OR (? <= end_date AND end_date <= ?)
          OR (start_date < ? AND ? < end_date)",
          start_date, end_date,
          start_date, end_date,
          start_date, end_date
        ).limit(1)

        if not_available.length > 0
          @arrSpaces.delete(space)
        end
      end
    end
  end

  def admin
    if params[:admin].present?
      if params[:admin][:usr] == "innospace" && params[:admin][:pwd] == "1nn0sp4c3"
        redirect_to "/main"
      end
    end
  end

end
