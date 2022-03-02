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
    let(:exit_station_double) { double :exit_station_double}

    before do
      @card = Oystercard.new
      @card.top_up(Oystercard::MINIMUM_FARE)
    end
    
    # it 'should be able to touch in and change in_journey to true' do
    #   @card.touch_in(entry_station_double)
    #   expect(@card).to be_in_journey
    # end

    # it 'should be able to touch out and change in_journey to false' do
    #   @card.touch_in(entry_station_double)
    #   @card.touch_out(exit_station_double)
    #   expect(@card).to_not be_in_journey
    # end
    
    it 'should raise an error when card does not have enough for minimum fare(1)' do      
      expect { subject.touch_in(entry_station_double) }.to raise_error('insufficient funds')
    end

    it 'should change the balance by the minimum fare after touching out' do
      @card.touch_in(entry_station_double)
      expect { @card.touch_out(exit_station_double) }.to change { @card.balance }.by(-Oystercard::MINIMUM_FARE)
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