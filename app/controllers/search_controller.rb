class SearchController < ApplicationController

  def show
    if params[:search].present? && params[:search].strip != ""
      session[:address_search] = params[:search]
    end

    arrResult = Array.new

    if session[:address_search] && session[:address_search] != ""
      @spaces_address = Space.where(active: true).near(session[:address_search], 5, order: 'distance')
    else
      @spaces_address = Space.where(active: true).all
    end

    @search = @spaces_address.ransack(params[:q])
    @spaces = @search.result

    @arrSpaces = @spaces.to_a

    if (params[:start_date] && params[:end_date] && !params[:start_date].empty? & !params[:end_date].empty?)

      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])

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

end
