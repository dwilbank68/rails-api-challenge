class User < ActiveRecord::Base
    before_create :set_auth_token

    has_many :teams
    has_many :monsters

    validates :name,
              :presence => true,
              :length => {:in => 2..25},
              :uniqueness => {:case_sensitive => false}

    private

    def set_auth_token
        return if auth_token.present?
        self.auth_token = generate_auth_token
    end

    def generate_auth_token
        loop do
            token = SecureRandom.hex
            break token unless self.class.exists?(auth_token:token)
        end
    end

end