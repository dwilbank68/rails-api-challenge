class MonsterSerializer < ActiveModel::Serializer
  attributes :name, :power, :_type, :weakness, :strength
end
