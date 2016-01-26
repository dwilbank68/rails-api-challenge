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

    if !valid_monster_id(monster_id)
      render json: {message:"That is not a valid monster"}, status:403
      return
    elsif !valid_team_id(team_id)
      render json: {message:"That is not a valid team"}, status:403
      return
    else
      true
    end

    team = Team.find_by_id(team_id)
    monster = Monster.find_by_id(monster_id)


    if !team_belongs_to_user(team)
      render json: {message:"That is not your team"}, status:403
    elsif !monster_belongs_to_user(monster)
      render json: {message:"That is not your monster"}, status:403
    elsif !team_has_space(team)
      render json: {message:"That team already has #{MAX_MONSTER_COUNT_PER_TEAM} monsters."}, status: 403
    else
      monster.team_id = team_id
      if monster.save
        render json: {message:"added to team #{team.name}"}, status: 200
      else
        render json: monster.errors, status: 422
      end
    end

  end

  def remove_monster
    team_id = params[:team_id].to_i
    monster_id = params[:monster_id].to_i

    if !valid_monster_id(monster_id)
      render json: {message:"That is not a valid monster"}, status:403
      return
    elsif !valid_team_id(team_id)
      render json: {message:"That is not a valid team"}, status:403
      return
    else
      true
    end

    team = Team.find_by_id(team_id)
    monster = Monster.find_by_id(monster_id)


    if !team_belongs_to_user(team)
      render json: {message:"That is not your team"}, status:403
      return
    elsif !monster_belongs_to_user(monster)
      render json: {message:"That is not your monster"}, status:403
      return
    else
      monster.team_id = nil
      if monster.save
        render json: {message:"removed from #{team.name}"}, status: 200
      else
        render json: monster.errors, status: 422
      end
    end
  end

  ##################################################################

  private

  def team_params
    params.require(:team).permit(:name)
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

  ###################################################################

  protected

  def get_user
    token = request
                .headers["Authorization"]
                .split('=')
                .last
    if @user = User.find_by(auth_token: token)
      puts @user.name
    else
      render_unauthorized
    end
  end

end

