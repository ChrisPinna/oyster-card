class Journey 

  attr_accessor :exit_station
  attr_reader :entry_station

  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  def initialize(entry_station = nil)
    @entry_station = entry_station
    @exit_station = nil
  end

  def in_journey?
    @exit_station == nil
  end

  def end_journey(station)
    @exit_station = station
  end

  def calculate_fare
    return PENALTY_FARE if @exit_station == nil || @entry_station == nil
    return MINIMUM_FARE if @exit_station != nil
  end
end
