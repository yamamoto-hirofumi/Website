require "rails_helper"

RSpec.describe "UserRoomモデルのテスト", type: :model do
  let(:user_room) { create(:user_room) }

  describe "バリデーションのテスト" do
    it "user_idとroom_idがある場合、有効であること" do
      expect(user_room).to be_valid
    end
    it "user_idがない場合、無効であること" do
      user_room.user_id = nil
      expect(user_room).to be_invalid
    end
    it "room_idがない場合、無効であること" do
      user_room.room_id = nil
      expect(user_room).to be_invalid
    end
  end

  describe "アソシエーションのテスト" do
    context "Userモデルとの関係" do
      it "N:1となっている" do
        expect(UserRoom.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context "Roomモデルとの関係" do
      it "N:1となっている" do
        expect(UserRoom.reflect_on_association(:room).macro).to eq :belongs_to
      end
    end
  end
end
