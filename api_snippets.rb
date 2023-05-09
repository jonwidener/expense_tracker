class API < Sinatra::Base
  def initializa(ledger:)
    @ledger = ledger
    super
  end
end

app = API.new(ledger: Ledger.new)
