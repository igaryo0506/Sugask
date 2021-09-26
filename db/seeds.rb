User.create(name: "test",password: "password", password_confirmation: "password")
User.create(name: "test2",password: "password", password_confirmation: "password")
Room.create(name: "2020spring", number: "111111")
UserRoomRelationship.create(user_id: 1, room_id: 1)