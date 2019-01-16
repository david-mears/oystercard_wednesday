class OysterCard
attr_reader :balance, :in_journey, :entry_station

DEFAULT_BALANCE = 0
MAXIMUM_BALANCE = 90
MINIMUM_BALANCE = 1
MINIMUM_FARE = 2

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @entry_station = nil
  end

  def top_up(amount)
    raise error_message if balance_exceeds_limit?(amount)
    @balance += amount
  end

  def error_message
    "ERROR!! The Maximum balance is £#{OysterCard::MAXIMUM_BALANCE}"
  end

  def balance_exceeds_limit?(amount)
    (amount + balance) > MAXIMUM_BALANCE
  end

  def touch_in(origin_station)
    fail "Please top up" if balance < MINIMUM_BALANCE

    @entry_station = origin_station
  end

  def in_journey?
    return entry_station == nil ? false : true
  end

  def touch_out
    deduct(MINIMUM_FARE)
    @entry_station = nil
  end

  private

  def deduct(amount)
    @balance -= amount
  end

end
