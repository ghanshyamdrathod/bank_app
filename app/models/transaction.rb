class Transaction < ActiveRecord::Base
	belongs_to :account

	scope :debits, -> {where(name: 'debit').sum(:amount)}
	scope :credits, -> {where(name: 'credit').sum(:amount)}

	validates_presence_of  :amount, :account_id
	validates_numericality_of :amount, :integer_only => true

	def self.credit(amount, description)
		self.create(:name => 'credit', :amount => amount, :description => description)
	end

	def self.debit(amount, description)
		self.create(:name => 'debit', :amount => amount, :description => description)
	end

end
