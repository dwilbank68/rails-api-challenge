require 'rails_helper'

describe 'Monsters', type: :request do

    dummy_user = FactoryGirl.create( :user, :name => 'batman' )

    puts "dummy user auth_token is #{dummy_user.auth_token}"

    it "lists monsters" do
        get "http://localhost:3000/monsters?sort=name", nil, {"Authorization" => "Token token=3472ad005505541ff3f23d2bac20c55b"}
        expect(response.code).to eq 200
        json = JSON.parse(response.body)
        puts json
    end

end

#Davy's token
#3472ad005505541ff3f23d2bac20c55b

#Sharky's token
#3473d82fb3df8bc2bc9080faa4021398


# get_monsters_by_name(){
#     curl -i \
#     -H "Authorization: Token token=3472ad005505541ff3f23d2bac20c55b" \
#     -H "Accept: application/json" \
#     -H "Content-Type: application/json" \
#     http://localhost:3000/monsters?sort=name
# }
# get_monsters_by_type(){
#     curl -i \
#     -H "Authorization: Token token=3472ad005505541ff3f23d2bac20c55b" \
#     -H "Accept: application/json" \
#     -H "Content-Type: application/json" \
#     http://localhost:3000/monsters?sort=_type
# }
# get_monsters_by_weakness(){
#     curl -i \
#     -H "Authorization: Token token=3472ad005505541ff3f23d2bac20c55b" \
#     -H "Accept: application/json" \
#     -H "Content-Type: application/json" \
#     http://localhost:3000/monsters?sort=weakness
# }
# monster1_create(){
#     curl -v -X POST \
#         -H "Authorization: Token token=3472ad005505541ff3f23d2bac20c55b" \
#         -H "Accept: application/json" \
#         -H "Content-Type: application/json" \
#         -d @bin/monster1.json \
#         http://localhost:3000/monsters