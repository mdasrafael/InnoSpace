class BookingsController < ApplicationController
  before_action :authenticate_user!, except: [:notify]

  def preload
    space = Space.find(params[:space_id])
    today = Date.today
    bookings = space.bookings.where("start_date >= ? OR end_date >= ?", today, today).first

    render json: bookings
  end

  def preview
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    output = {
      conflict: is_conflict(start_date, end_date)
    }

    render json: output
  end

  def create
=begin trying to check if user is the space owner, can't access the booked space id
    current_user.spaces.each do |space|
      #value: @space.id
      if space.id == booking_params.fifth
        redirect_to space, alert: "Your booking has failed..."
        return false
      end
    end
=end
    space = Space.find(booking_params[:space_id])

    if booking_params[:start_date].blank?
      redirect_to space, alert: "Please inform a Start Date"
      return false
    elsif booking_params[:end_date].blank?
      redirect_to space, alert: "Please inform an End Date"
      return false
    end

    start_date = Date.parse(booking_params[:start_date])
    end_date = Date.parse(booking_params[:end_date])

    if start_date > end_date
      redirect_to space, alert: "The {end_date} can't be earlier than the {start_date}"
      return false
    end

    @booking_params = booking_params.to_h
    @booking = current_user.bookings.create(@booking_params)
    redirect_to your_events_path, notice: "Your booking has been registered..."


=begin OLD
    if params[:payment_method] == 'Book with Paypal'

      @booking_params = booking_params.to_h
      @booking_params[:payment_method] = 'paypal'

      @booking = current_user.bookings.create(@booking_params)


      #send request to Paypal
      values = {
        business: 'mdas.rafael-facilitator@gmail.com',
        cmd: '_xclick',
        upload: 1,
        notify_url: 'http://322c2da9.ngrok.io/notify',
        amount: @booking.total,
        item_name: @booking.space.space_name,
        item_number: @booking.id,
        quantity: '1',
        return: 'http://322c2da9.ngrok.io/your_events'
      }

      redirect_to "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query, notice: "Your booking has been registered..."

    elsif params[:payment_method] == 'Book with Credit Card'

      @booking_params = booking_params.to_h
      @booking_params[:payment_method] = 'creditcard'

      @booking = current_user.bookings.create(@booking_params)

      redirect_to "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query, notice: "Your booking has been registered..."

    else

    space = Space.find(params[:space_id])
      redirect_to space, alert: "Oops, something went wrong..."

    end
=end
  end

  def pay
    @booking = Booking.find(params[:id])

    if params[:payment_method] == 'paypal'
      #send request to Paypal
      values = {
        business: 'mdas.rafael-facilitator@gmail.com',
        cmd: '_xclick',
        upload: 1,
        notify_url: 'http://innospace.asia/notify',
        amount: @booking.total,
        currency_code: 'HKD',
        item_name: @booking.space.space_name,
        item_number: @booking.id,
        quantity: '1',
        return: 'http://innospace.asia/your_events'
      }

      redirect_to "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query, notice: "Your booking has been paid..."
    end

    @booking.update(:payment_method => params[:payment_method])
    @booking.update(:payment_status => true)

  end

  def confirm
    @booking = Booking.find(params[:id])
    @booking.update(:confirmed_at => params[:confirmed_at])

    redirect_to your_bookings_path, notice: "Informing your customer about your availability confirmation"
  end

  def cancel
    @booking = Booking.find(params[:id])
    @booking.update(:canceled_at => params[:canceled_at])

    redirect_to your_bookings_path, notice: "Informing your customer about the unavailability"
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy

    redirect_to your_bookings_path, notice: "Informing your customer about the unavailability"
  end

  protect_from_forgery except: [:notify]
  def notify
    params.permit!
    status = params[:payment_status]

    booking = Booking.find(params[:item_number])

    if status = "Completed"
      booking.update_attributes payment_status:true
    else
      booking.destroy
    end

    render nothing: true
  end

  def your_bookings
    @spaces = current_user.spaces
  end

  protect_from_forgery except: [:your_events]
  def your_events
    @events = current_user.bookings
  end

  private

    def is_conflict(start_date, end_date)
      space = Space.find(params[:space_id])

      check = space.bookings.where("? < start_date AND end_date < ?", start_date, end_date)
      check.size > 0? true : false
    end

    def booking_params
      params.require(:booking).permit(:start_date, :end_date, :price, :total, :space_id, :payment_method, :confirmed_at, :canceled)
    end
end
