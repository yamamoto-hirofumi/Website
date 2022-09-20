require "rails_helper"

RSpec.describe "PostTagモデルのテスト", type: :model do
  let(:post_tag) { create(:post_tag) }

  describe "バリデーションのテスト" do
    it "post_idとtag_idがある場合、有効であること" do
      expect(post_tag).to be_valid
    end
    it "post_idがない場合、無効であること" do
      post_tag.post_id = nil
      expect(post_tag).to be_invalid
    end
    it "tag_idがない場合、無効であること" do
      post_tag.tag_id = nil
      expect(post_tag).to be_invalid
    end
  end

  describe "アソシエーションのテスト" do
    context "Postモデルとの関係" do
      it "N:1となっている" do
        expect(PostTag.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end

    context "Tagモデルとの関係" do
      it "N:1となっている" do
        expect(PostTag.reflect_on_association(:tag).macro).to eq :belongs_to
      end
    end
  end
end
