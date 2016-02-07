MAX_TEAM_COUNT_PER_USER = 3
MAX_MONSTER_COUNT_PER_TEAM = 3

class TeamsController < ApplicationController

  before_action :get_user

  def index
    user_teams = @user.teams
    render json: user_teams, root: false, status: 200
  end

  def create
    if max_teams?
      render json: {message:"You have #{@user.teams.count} teams out of #{MAX_TEAM_COUNT_PER_USER} total allowed."}, status: 403
    else
      team = Team.new(team_params)
      team.user_id = @user.id
      if team.save
        render json: team, status: 201, location: teams_url
      else
        render json: team.errors, status: 422
      end
    end
  end

  def destroy
  end

  def add_monster
    team_id = params[:team_id].to_i
    monster_id = params[:monster_id].to_i

    # result will be a hash containing either error messages, or the actual team and monster models
    result = process_params(team_id, monster_id)

    if result[:valid]

      result[:monster].team_id = team_id
      if result[:monster].save
        render json: {message:"added to team #{result[:team].name}"}, status: 200
      else
        render json: result[:monster].errors, status: 422
      end

    else
        render json: {message:"#{result[:message]}"}, status: 422
    end

  end

  def remove_monster
    team_id = params[:team_id].to_i
    monster_id = params[:monster_id].to_i

    # result will be a hash containing either error messages, or the actual team and monster models
    result = process_params(team_id, monster_id)

    if result[:valid]

      result[:monster].team_id = nil
      if result[:monster].save
        render json: {message:"removed from team #{result[:team].name}"}, status: 200
      else
        render json: result[:monster].errors, status: 422
      end

    else
      render json: {message:"#{result[:message]}"}, status: 422
    end
  end


  # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  private

  def team_params
    params.require(:team).permit(:name)
  end

  def process_params(team_id, monster_id)
    result = {}
    result[:status] = 403   # unless params are legit
    result[:valid] = false  # unless params are legit
    result[:team] = nil     # unless params are legit
    result[:monster] = nil  # unless params are legit

    if !valid_monster_id(monster_id)
      result[:message] = "That is not a valid monster"
    elsif !valid_team_id(team_id)
      result[:message] = "That is not a valid team"
    else

      team = Team.find_by_id(team_id)
      monster = Monster.find_by_id(monster_id)

      # necessary because if we are REMOVING monsters,
      # we don't want to check how many monsters are in a team (line 106)
      calling_method = caller_locations(1,1)[0].label

      if !team_belongs_to_user(team)
        result[:message] = "That is not your team"
      elsif !monster_belongs_to_user(monster)
        result[:message] = "That is not your monster"
      elsif !team_has_space(team) && calling_method == "add_monster"
        result[:message] ="That team already has #{MAX_MONSTER_COUNT_PER_TEAM} monsters."
      else
        result[:status] = 200
        result[:valid] = true
        result[:team] = team
        result[:monster] = monster
      end
    end
    return result
  end

  def valid_monster_id(monster_id)
    return Monster.find_by_id(monster_id) ? true : false
  end

  def valid_team_id(team_id)
    return Team.find_by_id(team_id) ? true : false
  end


  def max_teams?
    @user.teams.count >= MAX_TEAM_COUNT_PER_USER
  end

  def monster_belongs_to_user(monster)
    return monster.user == @user ? true : false
  end

  def team_belongs_to_user(team)
    return team.user == @user ? true : false
  end

  def team_has_space(team)
    return team.monsters.count >= MAX_MONSTER_COUNT_PER_TEAM ? false : true
  end

    def get_user
    token = request
                .headers["Authorization"]
                .split('=')
                .last
    if @user = User.find_by(auth_token: token)
      # puts @user.name
    else
      render_unauthorized
    end
  end

end

