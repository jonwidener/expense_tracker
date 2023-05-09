require_relative '../config/sequel'

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  class Ledger
    def record(expense)
      missing = validate expense
      if missing.count > 0
        message = "Invalid expense: `#{missing.join "`, `"}` #{missing.count > 1 ? 'are' : 'is'} required"
        return RecordResult.new(false, nil, message)
      end

      DB[:expenses].insert(expense)
      id = DB[:expenses].max(:id)
      RecordResult.new(true, id, nil)
    end

    def expenses_on(date)
      DB[:expenses].where(date: date).all
    end

    private

    def validate(expense)
      params = %w(payee amount date)
      params.filter { |key| not expense.key? key }      
    end
  end
end
