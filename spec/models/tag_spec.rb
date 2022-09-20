require "rails_helper"

RSpec.describe "Tagモデルのテスト", type: :model do
  let(:tag) { create(:tag) }

  describe "バリデーションのテスト" do
    context "nameカラム" do
      it "タグ名がある場合、有効であること" do
        expect(tag).to be_valid
      end
      it "空でないこと" do
        tag.name = nil
        expect(tag).to be_invalid
      end
      it '20文字以上であること: 20文字は〇' do
        tag.name = Faker::Lorem.characters(number: 20)
        expect(tag).to be_valid
      end
      it "20字以下であること: 21文字は×" do
        tag.name = Faker::Lorem.characters(number: 21)
        expect(tag).to be_invalid
      end
    end
  end

  describe "アソシエーションのテスト" do
    context "postモデルとの関係" do
      it "1:Nとなっている" do
        expect(Tag.reflect_on_association(:posts).macro).to eq :has_many
      end
    end

    context "PostTagモデルとの関係" do
      it "1:Nとなっている" do
        expect(Tag.reflect_on_association(:post_tags).macro).to eq :has_many
      end
    end
  end
end
