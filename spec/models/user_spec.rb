require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { test_user.valid? }

    let!(:other_user) { FactoryBot.create(:user) }
    let(:user) { build(:user) }
    let(:test_user) { user }

    context "nameカラム" do
      it "空でないこと" do
        test_user.name = ""
        is_expected.to eq false
      end
      it "20文字以下であること: 20文字は〇" do
        user.name = Faker::Lorem.characters(number: 20)
        expect(user.valid?).to eq true
      end
      it "20文字以下であること: 21文字は×" do
        user.name = Faker::Lorem.characters(number: 21)
        expect(user.valid?).to eq false
      end
    end

    context "introductionカラム" do
      it "100文字以下であること: 100文字は〇" do
        user.introduction = Faker::Lorem.characters(number: 100)
        expect(user.valid?).to eq true
      end
      it "100文字以下であること: 101文字は×" do
        user.introduction = Faker::Lorem.characters(number: 101)
        expect(user.valid?).to eq false
      end
    end
  end

  describe "アソシエーションのテスト" do
    context "Postモデルとの関係" do
      it "1:Nとなっている" do
        expect(User.reflect_on_association(:posts).macro).to eq :has_many
      end
    end

    context "PostCommentモデルとの関係" do
      it "1:Nとなっている" do
        expect(User.reflect_on_association(:post_comments).macro).to eq :has_many
      end
    end

    context "Favoriteモデルとの関係" do
      it "1:Nとなっている" do
        expect(User.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end

    context "Relationshipモデルとの関係" do
      it "1:Nとなっている" do
        expect(User.reflect_on_association(:relationships).macro).to eq :has_many
      end
      it "1:Nとなっている(reverse_of_relationships)" do
        expect(User.reflect_on_association(:reverse_of_relationships).macro).to eq :has_many
      end
      it "1:Nとなっている(followers)" do
        expect(User.reflect_on_association(:followers).macro).to eq :has_many
      end
      it "1:Nとなっている(followings)" do
        expect(User.reflect_on_association(:followings).macro).to eq :has_many
      end
    end

    context "UserRoomモデルとの関係" do
      it "1:Nとなっている" do
        expect(User.reflect_on_association(:user_rooms).macro).to eq :has_many
      end
    end

    context "Chatモデルとの関係" do
      it "1:Nとなっている" do
        expect(User.reflect_on_association(:chats).macro).to eq :has_many
      end
    end

    context "Notificationモデルとの関係" do
      it "1:Nとなっている(active_notifications)" do
        expect(User.reflect_on_association(:active_notifications).macro).to eq :has_many
      end
      it "1:Nとなっている(passive_notifications)" do
        expect(User.reflect_on_association(:passive_notifications).macro).to eq :has_many
      end
    end

    context "LoginHistoryモデルとの関係" do
      it "1:Nとなっている" do
        expect(User.reflect_on_association(:login_histories).macro).to eq :has_many
      end
    end
  end

  context "メソッドのテスト" do
    it "followメソッドが正しく動くか" do
      user = create(:user)
      other_user = create(:user)
      expect { user.follow(other_user.id) }.to change(Relationship, :count).from(0).to(1)
    end
    it "unfollowメソッドが正しく動くか" do
      user = create(:user)
      other_user = create(:user)
      user.follow(other_user.id)
      expect { user.unfollow(other_user.id) }.to change(Relationship, :count).from(1).to(0)
    end
    it "following?メソッドが正しく動くか(true)" do
      user = create(:user)
      other_user = create(:user)
      user.follow(other_user.id)
      expect(user.following?(other_user)).to be_truthy
    end
    it "following?メソッドが正しく動くか(false)" do
      user = create(:user)
      other_user = create(:user)
      expect(user.following?(other_user)).to be_falsey
    end
    it "create_notification_follow!メソッドが正しく動くか" do
      other_user = create(:user)
      user = create(:user)
      before_notification_count = Notification.count
      user.follow(other_user.id)
      user.create_notification_follow!(other_user)
      after_notification_count = Notification.count
      expect(after_notification_count - before_notification_count).to eq 1
    end
  end
end
