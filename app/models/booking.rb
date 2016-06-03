class Booking < ActiveRecord::Base
  belongs_to :user
  belongs_to :space

  def total_in_cents
    total*100
  end

end
