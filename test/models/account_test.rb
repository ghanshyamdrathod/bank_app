require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def test_invalid_without_user_attributes
    account = Account.new
    assert !account.valid?
    assert account.errors[:user_id].any?
  end

  def test_valid_user
  	ok = [ 1, 5, 10, 15, 25]
    bad = [ "hello", "hi", "name", "rails" ]

    ok.each do |user|
      account = accounts(:one)
      account.user_id = user
      assert account.valid?(:save), account.errors.full_messages.join(",")
    end
    
    bad.each do |user|
      account = accounts(:one)
      account.user_id = user
      assert account.invalid?(:save)
    end
  end

  def test_unique_user
  	new_account = Account.new(
      :user_id => accounts(:one).id
    )
    assert !new_account.save
    assert new_account.errors[:user_id].include?("has already been taken")
  end

end
