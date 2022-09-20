require "rails_helper"

RSpec.describe "Relationshipモデルのテスト", type: :model do
  describe "アソシエーションのテスト" do
    context "N:1となっている" do
      it " Userモデル" do
        expect(Relationship.reflect_on_association(:follower).macro).to eq :belongs_to
        expect(Relationship.reflect_on_association(:followed).macro).to eq :belongs_to
      end
    end
  end
end
