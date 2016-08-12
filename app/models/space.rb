class Space < ActiveRecord::Base
  belongs_to :user
  has_many :photos
  has_many :bookings
  has_many :reviews

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validates :space_type, presence: true
  validates :capacity, presence: true
  validates :space_name, presence: true, length: {maximum: 100}
  validates :summary, presence: true, length: {maximum: 500}
  validates :address, presence: true
  validates :price, numericality: { only_integer: true, greater_than: 5 }

  def average_rating
    reviews.count == 0 ? 0 : reviews.average(:star).round(2)
  end

=begin trying to get a default image, but don't know how to get it without using the space
  def show_first_photo(space)
    if space.photos.length < 1
      default_photo = "/conference-room-32343.png"
      return default_photo.image.url(:thumb)
    else
      return space.photos[0].image.url(:thumb)
    end
  end
=end

end
