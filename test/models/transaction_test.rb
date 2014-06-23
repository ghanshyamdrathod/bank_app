require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def test_invalid_without_account_attributes
    transaction = Transaction.new
    assert !transaction.valid?
    assert transaction.errors[:account_id].any?
  end

  def test_valid_amount
  	ok = [ 1, 5, 10, 15, 25, 500]
    bad = [ -1, -500, "hello", "hi", "name", "rails" ]

    #check for credit-amount
    ok.each do |amount|
      transaction = transactions(:credit)
      transaction.amount = transaction.amount
      assert transaction.valid?(:save), transaction.errors.full_messages.join(",")
    end

    #check for debit-amount
    ok.each do |amount|
      transaction = transactions(:debit)
      transaction.amount = transaction.amount
      assert transaction.valid?(:save), transaction.errors.full_messages.join(",")
    end
    #check for credit-amount
    bad.each do |amount|
      transaction = transactions(:credit)
      transaction.amount = transaction.amount
      assert transaction.valid?(:save), transaction.errors.full_messages.join(",")
    end

    #check for debit-amount
    bad.each do |amount|
      transaction = transactions(:debit)
      transaction.amount = transaction.amount
      assert transaction.valid?(:save), transaction.errors.full_messages.join(",")
    end
  end

end
