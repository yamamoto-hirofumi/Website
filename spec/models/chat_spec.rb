require "rails_helper"

RSpec.describe "Chatモデルのテスト", type: :model do
  let(:chat) { create(:chat) }

  describe "バリデーションのテスト" do
    context "messageカラム" do
      it "messageがある場合、有効であること" do
        expect(chat).to be_valid
      end
      it "空でないこと" do
        chat.message = ""
        expect(chat).to be_invalid
      end
      it '100文字以下であること: 100文字は〇' do
        chat.message = Faker::Lorem.characters(number: 100)
        expect(chat).to be_valid
      end
      it "100字以下であること: 101文字は×" do
        chat.message = Faker::Lorem.characters(number: 101)
        expect(chat).to be_invalid
      end
    end

    it "user_idとroom_idがある場合、有効であること" do
      expect(chat).to be_valid
    end
    it "user_idがない場合、無効であること" do
      chat.user_id = nil
      expect(chat).to be_invalid
    end
    it "room_idがない場合、無効であること" do
      chat.room_id = nil
      expect(chat).to be_invalid
    end
  end

  describe "アソシエーションのテスト" do
    context "Userモデルとの関係" do
      it "N:1となっている" do
        expect(Chat.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context "Roomモデルとの関係" do
      it "N:1となっている" do
        expect(Chat.reflect_on_association(:room).macro).to eq :belongs_to
      end
    end
  end
end
