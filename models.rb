require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection
class User < ActiveRecord::Base
    has_secure_password
    validates :name,
        presence: true
    validates :password,
        length:{in: 5..10}
    has_many :user_room_relationships
    has_many :rooms, through: :user_room_relationships
end

class Room < ActiveRecord::Base
    has_many :user_room_relationships
    has_many :users, through: :user_room_relationships
    has_many :questions
end

class UserRoomRelationship < ActiveRecord::Base
    belongs_to :user
    belongs_to :room
end

class Question < ActiveRecord::Base
    belongs_to :room
end