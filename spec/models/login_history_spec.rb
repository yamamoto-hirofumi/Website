require "rails_helper"

RSpec.describe "LoginHistoryモデルのテスト", type: :model do
  describe "アソシエーションのテスト" do
    context "Userモデルとの関係" do
      it "N:1となっている" do
        expect(LoginHistory.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
  end
end
