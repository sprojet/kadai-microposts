class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers]

  def index
    @users = User.all.page(params[:page])
  end
=begin
users#index では、全ユーザの一覧が欲しいので User.all で取得しています。
また、ページネーションを適用させるために .page(params[:page]) を付けています。
=end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order('created_at DESC').page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
      #redirect_to @user は、 処理を users#show のアクションへと強制的に移動させるもの。
      #create アクション実行後に更に show アクションが実行され、show.html.erb が呼ばれる。
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
      #render :new は、単に users/new.html.erb を表示するだけ（users#newのアクションは実行しない）。
    end
  end

  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def favorites
    @user = User.find(params[:id]) #「user」が「favorite」してる投稿を取得。
    @favorites = @user.favorite_microposts.page(params[:page]) #「複数形」
    counts(@user)
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

=begin
Strong Paramter では、name, email, password, password_confirmation を許可します。
この password から暗号化され password_digest として保存されます。
password_confirmation は password の確認のために使用されます。
=end