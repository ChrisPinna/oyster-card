class Journey 

  attr_accessor :exit_station
  attr_reader :entry_station

  def initialize(entry_station)
    @entry_station = entry_station
    @exit_station = nil
  end

end
