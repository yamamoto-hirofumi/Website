require "rails_helper"

RSpec.describe "Postモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { test_post.valid? }

    let(:user) { FactoryBot.create(:user) }
    let!(:post) { build(:post, user_id: user.id) }

    let(:test_post) { post }

    context "titleカラム" do
      it "空でないこと" do
        test_post.title = ""
        is_expected.to eq false
      end
      it '50文字以上であること: 50文字は〇' do
        post.title = Faker::Lorem.characters(number: 50)
        is_expected.to eq true
      end
      it "50文字以下であること: 51文字は×" do
        post.title = Faker::Lorem.characters(number: 51)
        expect(post.valid?).to eq false
      end
    end

    context "contentカラム" do
      it "空でないこと" do
        test_post.content = ""
        is_expected.to eq false
      end
      it '150文字以下であること: 150文字は〇' do
        post.content = Faker::Lorem.characters(number: 150)
        is_expected.to eq true
      end
      it "150字以下であること: 151文字は×" do
        post.content = Faker::Lorem.characters(number: 151)
        expect(post.valid?).to eq false
      end
    end

    context "User_idカラム" do
      it "空でないこと" do
        post.user_id = nil
        expect(post).to be_invalid
      end
    end
  end

  describe "アソシエーションのテスト" do
    context "Userモデルとの関係" do
      it "N:1となっている" do
        expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context "PostCommentモデルとの関係" do
      it "1:Nとなっている" do
        expect(Post.reflect_on_association(:post_comments).macro).to eq :has_many
      end
    end

    context "Favoriteモデルとの関係" do
      it "1:Nとなっている" do
        expect(Post.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end

    context "PostTagモデルとの関係" do
      it "1:Nとなっている" do
        expect(Post.reflect_on_association(:post_tags).macro).to eq :has_many
      end
    end

    context "Tagモデルとの関係" do
      it "1:Nとなっている" do
        expect(Post.reflect_on_association(:tags).macro).to eq :has_many
      end
    end

    context "Notificationモデルとの関係" do
      it "1:Nとなっている" do
        expect(Post.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
  end
end
