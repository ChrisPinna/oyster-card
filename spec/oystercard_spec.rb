require 'oystercard.rb'

describe Oystercard do

  context 'balance tests'do 

    it 'should have a balance of 0 by default' do
      expect(subject.balance).to eq(0)
    end

    it 'should have a top-up method that takes one argument' do
      expect(subject).to respond_to(:top_up).with(1).argument
    end 

    it 'should increase balance by specified amount' do 
      subject.top_up(10)
      expect(subject.balance).to eq(10) #balance is returned, this is what we are testing
    end

    it 'should raise error if balance would exceed £90' do
      subject.top_up(Oystercard::LIMIT)
      expect { subject.top_up(1) }.to raise_error Oystercard::EXCEEDS_MESSAGE
    end

  end

  context 'touch in / touch out support tests' do
    
    let(:entry_station_double) { double :entry_station_double }
    let(:exit_station_double) { double :exit_station_double }
    let(:journey_double) { double :journey_double }

    it 'should raise an error when card does not have enough for minimum fare(1)' do  
      allow(Journey).to receive(:new).and_return(journey_double)    
      expect { subject.touch_in(entry_station_double) }.to raise_error('insufficient funds')
    end

    before do
      @card = Oystercard.new
      @card.top_up(Oystercard::LIMIT)
    end

    it 'should change the balance by the minimum fare after touching out' do
      allow(Journey).to receive(:new).and_return(entry_station_double)   
      @card.touch_in(entry_station_double)
      allow(@card.current_journey).to receive(:end_journey).and_return(nil)
      allow(@card.current_journey).to receive(:calculate_fare).and_return(Oystercard::MINIMUM_FARE)
      allow(@card.current_journey).to receive(:in_journey?).and_return(true)
      expect { @card.touch_out(exit_station_double) }.to change { @card.balance }.by(-Oystercard::MINIMUM_FARE)
    end

    it 'should change balance by penalty fare when touch out without touching in' do
      allow(Journey).to receive(:new).and_return(journey_double)
      allow(journey_double).to receive(:end_journey).and_return(nil)
      allow(journey_double).to receive(:calculate_fare).and_return(6)
      allow(@card.current_journey).to receive(:in_journey?).and_return(false)
      expect { @card.touch_out(exit_station_double) }.to change { @card.balance }.by(-6)
    end
  end

  context 'storing journeys' do

    let(:entry_station) { double :station }
    let(:exit_station) { double :station }
    let(:started_journey) { double(entry_station: entry_station) }
    let(:complete_journey) { double(entry_station: entry_station, exit_station: exit_station) }
    
    before do
      @card = Oystercard.new
      @card.top_up(Oystercard::MINIMUM_FARE)
    end

    it 'should have an empty list of journeys by default' do
      expect(subject.all_journeys).to be_empty
    end

    it 'should have a journey stored after touching in' do 
      allow(Journey).to receive(:new).and_return(started_journey)
      @card.touch_in(entry_station)
      expect(@card.all_journeys).to eq([started_journey])
    end

  end

end