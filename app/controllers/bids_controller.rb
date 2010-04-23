class BidsController < ApplicationController
  def new
    @bid = Bid.new
  end
end
