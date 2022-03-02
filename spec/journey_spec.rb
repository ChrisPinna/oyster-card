require 'journey.rb'

describe Journey do

  let(:entry_station_double) { double :entry_station_double }
  let(:exit_station_double) { double :exit_station_double }
  #journey(:journey) { {:entry_station_double, :entry_station_double} }

  it 'should contain an entry station' do
    journey = Journey.new(entry_station_double)
    expect(journey.entry_station).to eq(entry_station_double) 
  end

  it 'should contain an exit station' do 
    journey = Journey.new(entry_station_double)
    journey.exit_station = exit_station_double
    expect(journey.exit_station).to eq(exit_station_double) 
  end
end
