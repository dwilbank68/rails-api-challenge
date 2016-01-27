MAX_MONSTER_COUNT_PER_USER = 20

class MonstersController < ApplicationController

  # before_action :authenticate
  before_action :get_user

  def index
    sort_by = request.params[:sort]

    user_monsters = @user.monsters
    user_monsters = user_monsters.sort_by {|user| user.name} if sort_by =='name'
    user_monsters = user_monsters.sort_by {|user| user.power} if sort_by =='power'
    user_monsters = user_monsters.sort_by {|user| user.weakness} if sort_by =='weakness'
    #todo - render error message if sort_by type is not valid
    render json: user_monsters, root: false, status: 200
  end

  def create
    if max_monsters?
      render json: "You have #{@user.monsters.count} monsters out of #{MAX_MONSTER_COUNT_PER_USER} total allowed.", status: 403
    else
      monster = Monster.new(monster_params)
      monster.user_id = @user.id
      if monster.save
        render json: monster, status: 201, location: monsters_url
      else
        render json: monster.errors, status: 422
      end
    end

  end

  def destroy
    #todo
  end

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


  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Monsters"'
    render json: 'Bad credentials', status: 401
  end

  private

  def monster_params
    params.require(:monster).permit(:name, :power, :_type, :_user_id, :team_id)
  end

  def max_monsters?
    @user.monsters.count >= MAX_MONSTER_COUNT_PER_USER
  end

end



