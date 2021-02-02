class BookingsController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  before_action :find_booking, only: [:accept, :deny]

  def create
    @pet = Pet.find(params[:pet_id])
    @booking = Booking.new(booking_params)
    @booking.user = current_user
    @booking.pet = @pet
    daily_price = @booking.pet.price_per_day
    @booking.price = (@booking.end_date - @booking.start_date) * daily_price
    if @booking.save
      redirect_to pet_path(@pet)
    else
      render :new
    end
    authorize @booking
  end

  def accept
    @booking.confirmed = true
    @booking.save

    authorize @booking
    redirect_to dashboard_index_path
  end

  def deny
    @booking.confirmed = false
    @booking.save

    authorize @booking
    redirect_to dashboard_index_path
  end
  
  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end

  def find_booking
    @booking = Booking.find(params[:id])
  end
end
