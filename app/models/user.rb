class User < ActiveRecord::Base

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable #, :validatable

  has_one :account, dependent: :destroy
  after_create :account_setup

  validates :password, presence: true, length: {minimum: 8, maximum: 128}, on: :create
  validates :password, length: {minimum: 8, maximum: 128}, on: :update, allow_blank: true

  status = ['active', 'inactive', 'deleted', 'freeze']

  after_initialize :set_defaults
  
  default_scope  { where(:status => "active") }

  validates_presence_of :email, :name
  validates_confirmation_of :email#, :message => ' addresses must match'
  validates_uniqueness_of :name, :allow_nil => true, :case_sensitive => false, :if => Proc.new { |u| u.name_changed? }
  validates_uniqueness_of :email, :case_sensitive => false, :if => Proc.new { |u| u.email_changed? }
  validates_length_of :name, :within => 3..255, :allow_nil => true
  validates_email_format_of :email, :if => Proc.new { |u| u.email_changed? }
  validates_format_of :name, :with => /\A[^\/;.,?%#]*\z/, :if => Proc.new { |u| u.name_changed? }
  validates_format_of :name, :with => /\A\S/, :message => "has leading whitespace", :if => Proc.new { |u| u.name_changed? }
  validates_format_of :name, :with => /\S\z/, :message => "has trailing whitespace", :if => Proc.new { |u| u.name_changed? }

  def account_setup
  	#setup account record on user creation.
  	Account.create(user_id: self.id)

  	#initial amount on user creation.
  	credit_amount(100, nil)
  end

  def credit_amount(amount, description)
  	#default description
  	description = description.nil? ? "Initial Credit form System by User #{self.name}" : description
  	account.transactions.credit(amount, description)
  end

  def debit_amount(amount, description)
  	account.transactions.debit(amount, description)
  end

  def balance
  	account.transactions.credits - account.transactions.debits
  end

  def allow_transaction(amount)
  	self.balance - amount < 0 ? false : true
  end

  def delete
    self.name = "user_#{self.id}"
    self.status = "deleted"
    self.save
  end

  private

  # Fill in default values for new notes
  def set_defaults
    self.status = "active" unless self.attribute_present?(:status)
  end

end
