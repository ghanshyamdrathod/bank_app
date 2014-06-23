class Account < ActiveRecord::Base
	belongs_to :user
	has_many :transactions, dependent: :destroy

	validates_presence_of :user_id
	validates_numericality_of :user_id, :integer_only => true
	validates_uniqueness_of :user_id

end
