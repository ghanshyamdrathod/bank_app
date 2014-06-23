require 'test_helper'

class UserTest < ActiveSupport::TestCase
	api_fixtures
  # test "the truth" do
  #   assert true
  # end

  def test_invalid_with_empty_attributes
    user = User.new
    assert !user.valid?
    assert user.errors[:email].any?
    assert user.errors[:password].any?
    assert user.errors[:name].any?
  end

  def test_unique_email
    new_user = User.new(
      :email => users(:normal_user).email,
      :password => Digest::MD5.hexdigest('test'),
      :name => "new user"
    )
    assert !new_user.save
    assert new_user.errors[:email].include?("has already been taken")
  end

  def test_unique_display_name
    new_user = User.new(
      :email => "tester@user.org",
      :password => Digest::MD5.hexdigest('test'),
      :name => users(:normal_user).name
    )
    assert !new_user.save
    assert new_user.errors[:name].include?("has already been taken")
  end

  def test_email_valid
    ok = %w{ a@s.com test@user.me.uk hello_local@user.ng 
    test_local@user.org test-local@example.com }
    bad = %w{ hi ht@ n@ @.com help@.me.uk help"hi.me.uk }
	
	ok.each do |email|
      user = users(:normal_user)
      user.email = email
      assert user.valid?(:save), user.errors.full_messages.join(",")
    end
    
    bad.each do |email|
      user = users(:normal_user)
      user.email = email
      assert user.invalid?(:save), "#{email} is valid when it shouldn't be" 
    end    
  end

  def test_display_name_length
    user = users(:normal_user)
    user.name = "123"
    assert user.valid?, " should allow nil display name"
    user.name = "12"
    assert !user.valid?, "should not allow 2 char name"
    user.name = ""
    assert !user.valid?
    user.name = nil
    # Don't understand why it isn't allowing a nil value, 
    # when the validates statements specifically allow it
    # It appears the database does not allow null values
    assert !user.valid?
  end

  def test_display_name_valid
    # Due to sanitisation in the view some of these that you might not 
    # expact are allowed
    # However, would they affect the xml planet dumps?
    ok = [ "Name", "'me", "he\"", "<hr>", "*ho", "\"help\"@"]
    # These need to be 3 chars in length, otherwise the length test above
    # should be used.
    bad = [ "<hr/>", "test@example.com", "s/f", "aa/", "aa;", "aa.",
            "aa,", "aa?", "/;.,?" ]
    ok.each do |name|
      user = users(:normal_user)
      user.name = name
      assert user.valid?, "#{name} is invalid, when it should be"
    end
    
    bad.each do |name|
      user = users(:normal_user)
      user.name = name
      assert !user.valid?, "#{name} is valid when it shouldn't be"
      assert user.errors[:name].include?("is invalid")
    end
  end

  def test_delete
    user = users(:normal_user)
    user.delete
    assert_equal "user_#{user.id}", user.name
    assert_equal "deleted", user.status
  end



  # def test_user_with_account
  # 	user = users(:normal_user)
  # 	user.account_setup
  # end

end
