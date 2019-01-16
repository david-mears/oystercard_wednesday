require 'oystercard'

RSpec.describe OysterCard do
  let(:oystercard) { OysterCard.new }
  let(:station) { double 'station' }

  it { is_expected.to respond_to(:top_up).with(1).argument }
  it { is_expected.to respond_to(:in_journey?) }

  it "initializes with balance of 0" do
      expect(subject.balance).to eq(0)
  end

  describe '#top_up' do
      it "increases balance of card" do
          expect(subject.top_up(15)).to eq(15)
      end

      it "confirms balance is updated as expected" do
          subject.top_up(15)
          expect(subject.balance).to eq(15)
      end

      it 'raises error if new balance exceeds maximum balance' do
          maximum_balance = OysterCard::MAXIMUM_BALANCE
          subject.top_up(maximum_balance)
          expect { subject.top_up(1) }.to raise_error "ERROR!! The Maximum balance is £#{OysterCard::MAXIMUM_BALANCE}"
      end
    end

    describe '#in_journey?' do
      it "initializes as false" do
        expect(subject.in_journey?).to eq(false)
      end
    end

    describe '#touch_in' do
      it "changes @in_journey" do
        subject.top_up(OysterCard::MINIMUM_BALANCE)
        subject.touch_in(station)
        expect(subject.in_journey?).to eq true
      end

      it "throws an error if insufficient funds" do
        subject.instance_variable_set(:@balance, 0)
        expect { subject.touch_in(station) }.to raise_error "Please top up"
      end

      it "remembers the entry station" do
        subject.top_up OysterCard::MINIMUM_BALANCE
        subject.touch_in(station)
        expect(subject.entry_station).to eq(station)
      end
    end

    describe '#touch_out' do

      it "changes in_journey?" do
        subject.top_up OysterCard::MINIMUM_BALANCE
        subject.touch_in(station)
        subject.touch_out
        expect(subject.in_journey?).to eq false
      end

      it "deducts the fare" do
        expect{ subject.touch_out }.to change{ subject.instance_variable_get(:@balance) }.by(-OysterCard::MINIMUM_FARE)
      end

      it "forgets the entry_station on touch_out" do
        subject.top_up(OysterCard::MINIMUM_BALANCE)
        subject.touch_in(station)
        subject.touch_out
        expect(subject.entry_station).to eq nil
      end

    end

end
