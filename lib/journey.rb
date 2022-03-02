class Journey 

  attr_accessor :exit_station
  attr_reader :entry_station

  def initialize(entry_station)
    @entry_station = entry_station
    @exit_station = nil
  end

  def in_journey?
    @exit_station == nil
  end

  def end_journey(station)
    @exit_station = station
  end
end
