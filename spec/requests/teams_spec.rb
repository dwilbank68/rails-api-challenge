require 'rails_helper'

describe 'Teams', type: :request do

    it "is created via a post method" do
        # before do
            @user = User.create(:name => "TeamCreator")
        # end

        expect(Team.count).to eq(0)
        post "http://localhost:3000/teams",
             { team: { name:"Team Scooby Doo" }  },
             {"ACCEPT" => "application/json", "Authorization" => @user.auth_token}
        expect(Team.count).to eq(1)
    end

    it "lists teams with all associated monsters" do

        @user = User.create(:name => "PeanutBoy")
        3.times do |i|
            @team = Team.create name:"Team#{i}", user_id: @user.id
            3.times do |j|
                @monster = Monster.create name:"Monster#{i}#{j}", power:"Hears beetles", _type:"fire", user_id:@user.id, team_id:@team.id
                @team.monsters << @monster
            end
            @user.teams << @team
        end

        get "http://localhost:3000/teams", nil, {"Authorization" => @user.auth_token}
        expect(response.code).to eq("200")
        json = JSON.parse(response.body)
        expect(json[0]['name']).to eq('Team0')
        expect(json[1]['name']).to eq('Team1')
        expect(json[2]['name']).to eq('Team2')
        expect(json[0]['monsters'].length).to eq 3
        expect(json[1]['monsters'].length).to eq 3
        expect(json[2]['monsters'].length).to eq 3
        expect(json[2]['monsters'].length).not_to eq 2
    end

    context "when max number of teams per user is exceeded" do

        before do
            @user2 = User.create(:name => "PeanutBoy")
            3.times do |i|
                @team = Team.create name:"Team#{i}", user_id: @user2.id
                @user2.teams << @team
            end
        end

        it "return an error message" do
            post "http://localhost:3000/teams",
                 { team: { name:"4th Team" }  },
                 {"ACCEPT" => "application/json", "Authorization" => @user2.auth_token}

            expect(response.code).to eq("403")
            assert_equal Mime::JSON, response.content_type
            expect(response.body).to eq({message: "You have 3 teams out of 3 total allowed."}.to_json)
        end

    end

    it "monster can be added to and deleted from a team" do
        @user = User.create(:name => "Eugene")
        @team = Team.create(:name => "Bowlers", :user_id => @user.id)
        @monster1 = Monster.create name:"Crunchy Bill", power:"Invisible Breath", _type:"wind", user_id:@user.id

        expect(@team.monsters.count).to eq(0)

        post "http://localhost:3000/teams/#{@team.id}/add_monster/#{@monster1.id}",
             {},
             {"ACCEPT" => "application/json", "Authorization" => @user.auth_token}
        expect(@team.monsters.count).to eq(1)

        delete "http://localhost:3000/teams/#{@team.id}/remove_monster/#{@monster1.id}",
             {},
             {"ACCEPT" => "application/json", "Authorization" => @user.auth_token}
        expect(@team.monsters.count).to eq(0)

    end

    context "when max number of monsters per team is exceeded" do
        before do
            @user = User.create(:name => "Eugene")
            @team = Team.create(:name => "Bowlers", :user_id => @user.id)
            @monster1 = Monster.create name:"Crunchy Bill", power:"Invisible Breath", _type:"wind", user_id:@user.id
            @monster2 = Monster.create name:"Picknicky", power:"Coughs like a goose", _type:"electric", user_id:@user.id
            @monster3 = Monster.create name:"Tapwater 89", power:"Folds paper boats", _type:"water", user_id:@user.id
            @monster4 = Monster.create name:"UltraCat", power:"Smokes", _type:"wind", user_id:@user.id
            @team.monsters << [@monster1, @monster2, @monster3]
        end

        it "returns an error message" do
            post "http://localhost:3000/teams/#{@team.id}/add_monster/#{@monster4.id}",
                 {},
                 {"ACCEPT" => "application/json", "Authorization" => @user.auth_token}
            expect(response.body).to eq({message: "That team already has 3 monsters."}.to_json)
        end
    end

    context "When an invalid auth token, monster_id, or team_id is sent" do
        before do
            @user = User.create(:name => "Eugene")
            @team = Team.create(:name => "Bowlers", :user_id => @user.id)
            @monster1 = Monster.create name:"Crunchy Bill", power:"Invisible Breath", _type:"wind", user_id:@user.id
            @monster2 = Monster.create name:"Picknicky", power:"Coughs like a goose", _type:"electric", user_id:@user.id
            @monster3 = Monster.create name:"Tapwater 89", power:"Folds paper boats", _type:"water", user_id:@user.id

            @user2 = User.create(:name => 'Someone Else')
            @team2 = Team.create(:name => "Someone Else's Team", :user_id => @user2.id)
            @monster4 = Monster.create name:"Someone Else's Monster", power:"Not In Mood", _type:"electric", user_id:@user2.id
        end

        it "rejects unknown auth tokens with a message" do
            post "http://localhost:3000/teams/#{@team.id}/add_monster/#{@monster4.id}",
                 {},
                 {"ACCEPT" => "application/json", "Authorization" => '99999999999999999'}
            expect(response.body).to eq({message: "Bad credentials"}.to_json)
        end

        it "rejects unauthorized post requests with a message" do
            post "http://localhost:3000/teams/#{@team2.id}/add_monster/#{@monster1.id}",
                 {},
                 {"ACCEPT" => "application/json", "Authorization" => @user.auth_token}
            expect(response.body).to eq({message: "That is not your team"}.to_json)
            post "http://localhost:3000/teams/#{@team.id}/add_monster/#{@monster4.id}",
                 {},
                 {"ACCEPT" => "application/json", "Authorization" => @user.auth_token}
            expect(response.body).to eq({message: "That is not your monster"}.to_json)
        end

        it "rejects invalid post requests with a message" do
            post "http://localhost:3000/teams/888/add_monster/#{@monster1.id}",
                 {},
                 {"ACCEPT" => "application/json", "Authorization" => @user.auth_token}
            expect(response.body).to eq({message: "That is not a valid team"}.to_json)
            post "http://localhost:3000/teams/#{@team.id}/add_monster/98989",
                 {},
                 {"ACCEPT" => "application/json", "Authorization" => @user.auth_token}
            expect(response.body).to eq({message: "That is not a valid monster"}.to_json)
        end

        it "rejects unauthorized delete requests with a message" do
            delete "http://localhost:3000/teams/#{@team2.id}/remove_monster/#{@monster1.id}",
                 {},
                 {"ACCEPT" => "application/json", "Authorization" => @user.auth_token}
            expect(response.body).to eq({message: "That is not your team"}.to_json)
            delete "http://localhost:3000/teams/#{@team.id}/remove_monster/#{@monster4.id}",
                 {},
                 {"ACCEPT" => "application/json", "Authorization" => @user.auth_token}
            expect(response.body).to eq({message: "That is not your monster"}.to_json)
        end

        it "rejects invalid delete requests with a message" do
            delete "http://localhost:3000/teams/888/remove_monster/#{@monster1.id}",
                 {},
                 {"ACCEPT" => "application/json", "Authorization" => @user.auth_token}
            expect(response.body).to eq({message: "That is not a valid team"}.to_json)
            delete "http://localhost:3000/teams/#{@team.id}/remove_monster/98989",
                 {},
                 {"ACCEPT" => "application/json", "Authorization" => @user.auth_token}
            expect(response.body).to eq({message: "That is not a valid monster"}.to_json)
        end

    end

end

#
# team1_remove_monster_bad_monster_id(){
#     curl -X PATCH \
#         -H "Authorization: Token token=3472ad005505541ff3f23d2bac20c55b" \
#         -H "Accept: application/json" \
#         -H "Content-Type: application/json" \
#         http://localhost:3000/teams/3/remove_monster/22454
# }
#
# team1_remove_monster_bad_team_id(){
#     curl -X PATCH \
#         -H "Authorization: Token token=3472ad005505541ff3f23d2bac20c55b" \
#         -H "Accept: application/json" \
#         -H "Content-Type: application/json" \
#         http://localhost:3000/teams/454543/remove_monster/2
# }
