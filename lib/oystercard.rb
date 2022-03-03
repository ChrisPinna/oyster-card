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
    check_for_incomplete_journey
    raise 'insufficient funds' if @balance < MINIMUM_FARE
    new_journey(station)
  end

  def touch_out(station)
    check_for_entry_station
    @current_journey.end_journey(station)
    deduct(@current_journey.calculate_fare)
  end

  private

  def new_journey(station = nil)
    @current_journey = Journey.new(station)
    add_journey_to_journey_history
  end

  def add_journey_to_journey_history
    @journey_history << @current_journey
  end

  def check_for_entry_station
    if @current_journey.in_journey? == false || @journey_history.empty? == true
      new_journey
    end
  end

  def check_for_incomplete_journey
    if @current_journey.in_journey? == true
      deduct(@current_journey.calculate_fare)
    end
  end

  def deduct(amount)
    @balance -= amount
  end
end