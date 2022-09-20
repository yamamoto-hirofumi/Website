require "rails_helper"

RSpec.describe "Notificationモデルのテスト", type: :model do
  describe "アソシエーションのテスト" do
    context "Userモデルとの関係" do
      it "N:1となっている" do
        expect(Notification.reflect_on_association(:visiter).macro).to eq :belongs_to
        expect(Notification.reflect_on_association(:visited).macro).to eq :belongs_to
      end
    end

    context "N:1となっている" do
      it "PostCommentモデル" do
        expect(Notification.reflect_on_association(:post_comment).macro).to eq :belongs_to
      end
      it "Postモデル" do
        expect(Notification.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
  end
end
