class ReviewsController < ApplicationController

def create
  @review = current_user.reviews.create(review_params)
  redirect_to @review.space
end

def destroy
  @review = Review.find(params[:id])
  space = @review.space
  @review.destroy

  redirect_to space
end

private
  def review_params
    params.require(:review).permit(:comment, :star, :space_id)
  end

end
