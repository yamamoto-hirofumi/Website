# require 'rails_helper'

# RSpec.describe PostCommentsController, type: :request do
#     let(:user) { create(:user) }
#     let(:other_user) { create(:user) }
#     let(:rerationship) { user.reverse_of_relationships.build(followed_id: other_user.id) }

#   describe "createのテスト" do
#     before do
#       sign_in(user)
#     end

#     it "Ajexが反応する" do
#       post user_relationships_path(other_user.id), xhr: true
#       expect(response.content_type).to eq 'text/javascript'
#     end

#     it "フォローする" do

#       #binding.pry
#       #expect(user.following?(other_user)).to change(user.followings, :count).by(1)
#       #post user_relationships_path(other_user.id)
#       expect { post user_relationships_path(other_user.id), xhr: true,
# params: { user_id: other_user.id } }.to change(user.followings, :count).by(1)
#     end
#   end

#   describe "destroyのテスト" do
#     before do
#       sign_in(user)
#     end
#     it "Ajexが反応する" do
#       delete user_relationships_path(other_user.id), xhr: true
#       expect(response.content_type).to eq 'text/javascript'
#     end
#     it "フォロー解除する" do
#       follower_id  { FactoryBot.create(:user).id }
#       followed_id  { FactoryBot.create(:user).id }
#       expect { delete user_relationships_path(user.id), xhr: true,
# params: { follower_id: other_user.id, followed_id: user.id } }.to
# change(user.followings, :count).by(0)
#     end
#   end
# end
