require_relative 'journey.rb'

class Oystercard
  
  attr_reader :balance, :current_journey, :all_journeys
  LIMIT = 90
  EXCEEDS_MESSAGE = "Denied. Balance would exceed #{LIMIT}"
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
    @all_journeys = []
  end

  def top_up(amount)
    raise EXCEEDS_MESSAGE if exceeds?(amount)
    @balance += amount
  end

  def exceeds?(amount)
    @balance + amount > LIMIT
  end

  def touch_in(station)
    raise 'insufficient funds' if @balance < MINIMUM_FARE
    @current_journey = Journey.new(station)
    @all_journeys << @current_journey
  end

  def touch_out(station)
    deduct(MINIMUM_FARE)
    # @all_journeys.last.exit_station = station
    @current_journey.end_journey(station)
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end