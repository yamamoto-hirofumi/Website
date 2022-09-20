require 'rails_helper'

RSpec.describe PostCommentsController, type: :request do
  let(:user) { create(:user) }
  let(:posts) { create(:post) }
  let(:post_comments) { create(:post_comment) }

  describe "createのテスト" do
    it "Ajexが反応する" do
      post post_post_comments_path(posts.id), xhr: true,
                                              params: { post_id: posts.id, id: post_comments.id }
      expect(response.content_type).to eq 'text/javascript'
    end

    it "コメント投稿する" do
      expect do
        post post_post_comments_path(posts.id), xhr: true,
                                                params: { post_id: posts.id, id: post_comments.id }
      end .to change(PostComment, :count).by(1)
    end
  end

  describe "destroyのテスト" do
    it "Ajexが反応する" do
      delete post_post_comment_path(post_comments.post, post_comments), xhr: true, params:
      { post_id: posts.id, id: post_comments.id }
      expect(response.content_type).to eq 'text/javascript'
    end
    it "コメント削除" do
      post_comments = create(:post_comment)
      expect do
        delete post_post_comment_path(post_comments.post, post_comments), xhr: true, params:
        { post_id: posts.id, id: post_comments.id }
      end .to change(PostComment, :count).by(0)
    end
  end
end
