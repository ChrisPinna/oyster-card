require_relative 'journey.rb'

class Oystercard
  
  attr_reader :balance, :current_journey, :journey_history
  LIMIT = 90
  EXCEEDS_MESSAGE = "Denied. Balance would exceed #{LIMIT}"
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
    @journey_history = []
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
    add_journey_to_journey_history
  end

  def touch_out(station)
    if @current_journey.in_journey? == false || @journey_history.empty? == true
      @current_journey = Journey.new
      add_journey_to_journey_history
    end
    @current_journey.end_journey(station)
    deduct(@current_journey.calculate_fare)
  end

  def add_journey_to_journey_history
    @journey_history << @current_journey
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end