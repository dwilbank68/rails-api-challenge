require 'rails_helper'

describe 'Monsters', type: :request do

    context "when sort type is set in the query" do

        before do
          @user = User.create(:name => "PeanutBoy")
          @monster1 = Monster.create name:"Crunchy Bill", power:"Invisible Breath", _type:"wind", user_id:@user.id
          @monster2 = Monster.create name:"Picknicky", power:"Coughs like a goose", _type:"electric", user_id:@user.id
          @monster3 = Monster.create name:"Tapwater 89", power:"Folds paper boats", _type:"water", user_id:@user.id
        end

        it "lists monsters sorted by name" do
            get "http://localhost:3000/monsters?sort=name", nil, {"Authorization" => @user.auth_token}
            expect(response.code).to eq("200")
            json = JSON.parse(response.body)
            expect(json[0]['name']).to eq('Crunchy Bill')
            expect(json[1]['name']).to eq('Picknicky')
            expect(json[2]['name']).to eq('Tapwater 89')
        end

        it "lists monsters sorted by power" do
            get "http://localhost:3000/monsters?sort=power", nil, {"Authorization" => @user.auth_token}
            expect(response.code).to eq("200")
            json = JSON.parse(response.body)
            expect(json[0]['power']).to eq('Coughs like a goose')
            expect(json[1]['power']).to eq('Folds paper boats')
            expect(json[2]['power']).to eq('Invisible Breath')
        end

        it "lists monsters sorted by weakness" do
            get "http://localhost:3000/monsters?sort=weakness", nil, {"Authorization" => @user.auth_token}
            expect(response.code).to eq("200")
            json = JSON.parse(response.body)
            expect(json[0]['weakness']).to eq('earth')
            expect(json[1]['weakness']).to eq('fire')
            expect(json[2]['weakness']).to eq('wind')
        end



    end

    context "when max number of monsters per user is exceeded" do

        before do
            @user2 = User.create(:name => "Scaffold Rigy")
            20.times do |i|
                @monster = Monster.create name:"Anonymonster#{i}", power:"Throws #{i} bricks", _type:"electric", user_id: @user2.id
                @user2.monsters << @monster
            end
        end

        it "returns an error message" do
            post "http://localhost:3000/monsters",
                 {
                     monster: {
                         name:"21st Monster",
                         power:"Ultimate Toenail",
                         _type:"water"
                     }
                 },
                 {"ACCEPT" => "application/json", "Authorization" => @user2.auth_token}

            expect(response.code).to eq("403")
            assert_equal Mime::JSON, response.content_type
            expect(response.body).to eq({message: "You have 20 monsters out of 20 total allowed."}.to_json)
        end

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


