STRENGTHS_WEAKNESSES = {
    fire: {
        strength: 'wind',
        weakness: 'water'
    },
    water: {
        strength: 'fire',
        weakness: 'earth'
    },
    earth: {
        strength: 'water',
        weakness: 'electric'
    },
    electric: {
        strength: 'earth',
        weakness: 'wind'
    },
    wind: {
        strength: 'electric',
        weakness: 'fire'
    }
}

class Monster < ActiveRecord::Base

    belongs_to :user
    belongs_to :team

    validates :name, :power, :_type, :user_id,
              :presence => true

    #uniqueness validations on name left out just to make manual testing easier

    def weakness
        STRENGTHS_WEAKNESSES[_type.to_sym][:weakness]
    end

    def strength
        STRENGTHS_WEAKNESSES[_type.to_sym][:strength]
    end


end
