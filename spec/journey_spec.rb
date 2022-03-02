require 'journey.rb'

describe Journey do

  let(:entry_station_double) { double :entry_station_double }
  let(:exit_station_double) { double :exit_station_double }
  let(:journey) { Journey.new(entry_station_double) }

  it 'should contain an entry station' do
    expect(journey.entry_station).to eq(entry_station_double) 
  end

  it 'should contain an exit station' do 
    journey.exit_station = exit_station_double
    expect(journey.exit_station).to eq(exit_station_double) 
  end

  it 'should return true for in_journey if exit station is nil' do
    expect(journey).to be_in_journey
  end 

  it 'should return false for in_journey if journey complete' do
    journey.exit_station = exit_station_double
    expect(journey).to_not be_in_journey
  end

end
