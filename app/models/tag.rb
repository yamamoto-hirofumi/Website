class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags
  validates :name, uniqueness: true, presence: true, length: { maximum: 20 }
  
  #　タグランキングに
  def self.tag_ranking
    find(PostTag.group(:tag_id).order(Arel.sql('count(tag_id)desc')).limit(5).pluck(:tag_id))
  end
end
