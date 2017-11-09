class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    if login(email, password)
      flash[:success] = 'ログインに成功しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ログインに失敗しました。'
      render 'new'
    end
    #session[:user_id] にログインユーザの id が代入された時点でログイン完了となる。
    #ブラウザの Cookie にもログイン情報が保存される。
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end

  private

  def login(email, password)
    @user = User.find_by(email: email)
    if @user && @user.authenticate(password)
      # ログイン成功
      session[:user_id] = @user.id
      return true
    else
      # ログイン失敗
      return false
    end
  end
end

=begin
上記で、仮定していた login(email, passsword) を private で定義します。
@user = User.find_by(email: email) によって、入力フォームの email と
同じメールアドレスを持つユーザを検索し @user へ代入します。
if @user によって、@user が存在するかを確認しています。
もし User.find_by(email: email) によって見つからなかった場合には、 
@user には nil が代入されていて、if文によって false として扱われます。
次に @user のパスワードが合っているか、@user.authenticate(password) で確認します。
もしパスワードが合っていなければ false が返ってきます。
そのため、if @user && @user.authenticate(password) は、 email, password の組み合わせが
間違っていた場合には、ログインできない仕様になっているということです。
最後に、 session[:user_id] = @user.id によって、ブラウザには Cookie として、
サーバには Session として、ログイン状態が維持されることになります。
=end