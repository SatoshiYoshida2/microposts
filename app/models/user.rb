class User < ActiveRecord::Base
  before_save { self.email = self.email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  validates :region, length: {maximum: 60 }
  validates :profile,length: {maximum: 160 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    
  has_secure_password
  has_many :microposts
  
  has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  
  has_many :follower_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
  has_many :follower_users, through: :follower_relationships, source: :follower  

  has_many :favorites
  
  has_many :favorite_microposts, through: :favorites, source: :favorite
  
  # 他のユーザーをフォローする
  def follow(other_user)
    # Relationship.find_or_create_by(followed_id: other_user.id, following_id: id)
    following_relationships.find_or_create_by(followed_id: other_user.id)
  end

  # フォローしているユーザーをアンフォローする
  def unfollow(other_user)
    following_relationship = following_relationships.find_by(followed_id: other_user.id)
    following_relationship.destroy if following_relationship
  end

  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    # Relationship.find_by(followed_id: other_user.id, following_id: id).present?
    following_users.include?(other_user)
  end
  
  def feed_items
    Micropost.where(user_id: following_user_ids + [self.id])
  end
  
  def favorite(other_micropost)
    favorites.find_or_create_by(favorite_id: other_micropost.id)
  end

  def unfavorite(other_micropost)
    favorite = favorites.find_by(favorite_id: other_micropost.id)
    favorite.destroy if favorite
  end
  
  def favorite?(other_micropost)
    favorite_microposts.include?(other_micropost)
  end
  
  mount_uploader :avatar, AvatarUploader
end

