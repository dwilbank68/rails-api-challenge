class Team < ActiveRecord::Base

    belongs_to :user
    has_many :monsters

    validates :name,
              :presence => true

    #uniqueness validations on name left out just to make manual testing easier



end
