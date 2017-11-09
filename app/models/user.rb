class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password

  has_many :microposts
  has_many :favorites
  has_many :favorite_microposts, through: :favorites, source: :micropost
  #Relationship モデルは User モデル同士の関係だったので、 User にもフォロー関係のコードを追加。
  #has_many :microposts の後に4行追加。
  has_many :relationships
  #has_many :microposts と同じく、User が Relationship と一対多である関係を示す。
  #user.relationships とすると Relationship 達を取得することができる。
  #あくまで取得できるものは Relationship 達であり、User ではない。
  has_many :followings, through: :relationships, source: :follow
  #has_many ..., through: ... で中間テーブルから先のモデルを参照しUser から直接、多対多の User 達を取得することができる。
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  #unless self == other_user によって、フォローしようとしている other_user が自分自身ではないかを検証。
  #self には user.follow(other) を実行したとき user が代入され、実行した User のインスタンスが self。
  #self.relationships.find_or_create_by(follow_id: other_user.id) は、見つかれば Relation を返し、
  #見つからなければ self.relationships.create(follow_id: other_user.id) としてフォロー関係を保存(create = build + save)する。

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  #self.followings によりフォローしている User 達を取得し、include?(other_user) によって other_user が含まれていないかを確認している。
  
  #user.follow(other_user) や、 user.unfollow(other_user) とすれば、フォロー／アンフォローできるように 
  #follow と unfollow メソッドを User モデルで定義。
  #また、既にフォローしているかどうか手軽に調査できるようにfollowing? メソッドも作成。
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  # user = User.new({...})
  # user.favorite(micropost)
  def favorite(other_micropost)
    unless self == other_micropost.user
      self.favorites.find_or_create_by(micropost_id: other_micropost.id)
    end
  end
  
  def unfavorite(other_micropost)
    favorite = self.favorites.find_by(micropost_id: other_micropost.id)
    favorite.destroy if favorite
  end
  
  def favorite?(other_micropost)
    self.favorite_microposts.include?(other_micropost)
  end
end