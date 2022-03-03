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

  it 'should calculate the fare for a complete journey' do
    journey.exit_station = exit_station_double
    expect(journey.calculate_fare).to eq(Journey::MINIMUM_FARE)
  end

  it 'should calculate a penalty fare if thir is no exit_station' do
    expect(journey.calculate_fare).to eq(Journey::PENALTY_FARE)
  end

  it 'should calculate a penalty fare if their is no entry_station' do
    no_entry_station_journey = Journey.new # create a journey instance without a entry station
    no_entry_station_journey.end_journey(exit_station_double)
    expect(no_entry_station_journey.calculate_fare).to eq(Journey::PENALTY_FARE)
  end
end
