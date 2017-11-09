module SessionsHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  #def current_user は、現在ログインしているユーザを取得するメソッド。
  #@current_user ||= User.find_by(id: session[:user_id]) は、@current_user に
  #既に現在のログインユーザが代入されていたら何もせず、代入されていなかったら User.find(...) から
  #ログインユーザを取得し、@current_user に代入する処理を1行で書いたもの。
=begin
if @current_user
  return @current_user
else
  @current_user = User.find_by(id: session[:user_id])
  return @current_user
end
=end

  def logged_in?
    !!current_user
  end
end

=begin
def logged_in? は、ユーザがログインしていれば true を返し、ログインしていなければ false を返します。
!!current_user はその通りに動作します。先ほど定義した current_user を使って、ユーザが現在ログインしているかを調べます。
存在していれば、ログインユーザのインスタンスが返ってきます。
そのインスタンスに対して ! (not) 演算子を適用すると、false になります。
そして更に false に ! 演算子を適用すると true になります。このトリックにより、ログインしていれば true が返されます。
逆に、ログインしていなければ current_user は nil を返します。
!nil は true であり、!true は false なので、ログインしていなければ false を返します。少しトリッキーですが、
Ruby ではコードを短く慣習があります。下記のように書いても同様に動作します。
=end

=begin
if current_user
  return true
else
  return false
end
=end