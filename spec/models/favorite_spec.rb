require "rails_helper"

RSpec.describe "Favoriteモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    let(:favorite) { create(:favorite) }
    let(:other_user) { create(:user) }
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    it "user_idとpost_idがある場合、有効であること" do
      expect(favorite).to be_valid
    end
    it "post_idがない場合、無効であること" do
      favorite.post_id = nil
      expect(favorite).to be_invalid
    end
    it "user_idがない場合、無効であること" do
      favorite.user_id = nil
      expect(favorite).to be_invalid
    end
  end

  describe "アソシエーションのテスト" do
    context "Userモデルとの関係" do
      it "N:1となっている" do
        expect(Favorite.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context "Postモデルとの関係" do
      it "N:1となっている" do
        expect(Favorite.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
  end

  it "いいねカウントのテスト" do
    before_favorite_count = Favorite.count
    favorite = create(:favorite)
    after_favorite_count = Favorite.count
    expect(after_favorite_count - before_favorite_count).to eq 1
  end
  it "create_notification_favorite!メソッドが正しく動くか" do
    other_user = create(:user)
    user = create(:user)
    before_notification_count = Notification.count
    favorite = create(:favorite)
    user.create_notification_follow!(other_user)
    after_notification_count = Notification.count
    expect(after_notification_count - before_notification_count).to eq 1
  end
end
