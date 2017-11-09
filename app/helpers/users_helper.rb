module UsersHelper
  def gravatar_url(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  end
end

=begin
Helper とは、View での処理を一部肩代わりするために存在します。
View は表示の役割を担っているので、複雑なプログラムを含めてしまうとすぐにでも読みづらくなり、
表示の崩れなどの原因にもなります。そのため、View を手伝う Helper という概念が生まれました。
今回であれば、gravatar_url メソッドを Helper に実装することで View の負担を減らします。
=end