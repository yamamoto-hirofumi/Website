require "rails_helper"

RSpec.describe "ログイン後のテスト", type: :request do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  before do
    visit new_user_session_path
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: user.password
    click_button "ログイン"
  end

  describe "ヘッダーのテスト" do
    before do
      visit root_path
    end

    context "表示内容の確認" do
      it "タイトルが表示されている" do
        expect(page).to have_content "Make enjoy life"
      end
      it "マイページへのリンクが表示されている" do
        expect(page).to have_content "マイページ"
      end
      it "通知のリンクが表示されている" do
        expect(page).to have_content "通知"
      end
      it "会員一覧のリンクが表示されている" do
        expect(page).to have_content "会員一覧"
      end
      it "投稿フォームのリンクが表示されている" do
        expect(page).to have_content "投稿フォーム"
      end
      it "投稿一覧のリンクが表示されている" do
        expect(page).to have_content "投稿一覧"
      end
      it "ログアウトのリンクが表示されている" do
        expect(page).to have_content "ログアウト"
      end
    end

    context "リンクの確認" do
      it "マイページへのリンク先が正しい" do
        expect(page).to have_link "マイページ", href: user_path(user)
      end
      it "通知のリンク先が正しい" do
        expect(page).to have_link "通知", href: notifications_path
      end
      it "会員一覧のリンク先が正しい" do
        expect(page).to have_link "会員一覧", href: users_path
      end
      it "投稿フォームのリンク先が正しいる" do
        expect(page).to have_link "投稿フォーム", href: new_post_path
      end
      it "投稿一覧のリンク先が正しい" do
        expect(page).to have_link "投稿一覧", href: posts_path
      end
    end
  end

  describe "ユーザログアウトのテスト" do
    let(:user) { create(:user) }

    before do
      @user = FactoryBot.create(:user)
      click_on "ログアウト"
    end

    context "ログアウト機能のテスト" do
      it "正しくログアウトできている: ログアウト後のリダイレクト先においてサイト紹介画面へのリンクが存在する" do
        expect(page).to have_link "サイト紹介", href: "/about"
      end
      it "ログアウト後のリダイレクト先が、トップになっている" do
        expect(current_path).to eq "/"
      end
    end
  end

  describe "投稿一覧画面の確認" do
    before do
      visit posts_path
    end

    context "表示内容が正しい" do
      it "URLが正しい" do
        expect(current_path).to eq "/posts"
      end
      it "投稿一覧と表示されている" do
        expect(page).to have_content "投稿一覧"
      end
      it "自分の名前と他人の名前のリンクが正しい" do
        expect(page).to have_link "", href: user_path(post.user)
        expect(page).to have_link "", href: user_path(other_post.user)
      end
      it "自分の投稿と他人の投稿のリンクが正しい" do
        expect(page).to have_link post.title, href: post_path(post)
        expect(page).to have_link other_post.title, href: post_path(other_post)
      end
      it "自分と他人のプロフィール画像と投稿画像が表示される" do
        expect(all("img").size).to eq(4)
      end
    end
  end

  describe "新規投稿画面のテスト" do
    before do
      visit new_post_path
    end

    context "表示内容が正しい" do
      it "URLが正しい" do
        expect(current_path).to eq "/posts/new"
      end
      it "新規投稿と表示されている" do
        expect(page).to have_content "新規投稿"
      end
      it "Titleフォームが表示される" do
        expect(page).to have_field "post[title]"
      end
      it "Titleフォームに値が入っていない" do
        expect(find_field("post[title]").text).to be_blank
      end
      it "Contentフォームが表示される" do
        expect(page).to have_field "post[content]"
      end
      it "Contentフォームに値が入っていない" do
        expect(find_field("post[content]").text).to be_blank
      end
      it "Tagフォームが表示される" do
        expect(page).to have_field "post[tag_ids]"
      end
      it "Tagフォームに値が入っていない" do
        expect(find_field("post[tag_ids]").text).to be_blank
      end
      it "新規投稿ボタンが表示される" do
        expect(page).to have_button "新規投稿"
      end
    end

    context "投稿成功時のテスト" do
      before do
        fill_in "post[title]", with: Faker::Lorem.characters(number: 5)
        fill_in "post[content]", with: Faker::Lorem.characters(number: 20)
        fill_in "post[tag_ids]", with: Faker::Lorem.characters(number: 2)
      end

      it "自分の新しい投稿が正しく保存される" do
        expect { click_button "新規投稿" }.to change(user.posts, :count).by(1)
      end
      it "リダイレクト先が、保存できた投稿の詳細画面になっている" do
        click_button "新規投稿"
        expect(current_path).to eq "/posts"
      end
    end
  end

  describe "ユーザー詳細画面のテスト" do
    before do
      visit user_path(user)
    end

    context "表示内容が正しい" do
      it "URLが正しい" do
        expect(current_path).to eq "/users/" + user.id.to_s
      end
      it "「マイページ」と表示される" do
        expect(page).to have_content "マイページ"
      end
      it "投稿のTitleが表示される" do
        expect(page).to have_content post.title
      end
      it "Titleのリンク先が正しい" do
        expect(page).to have_link post.title, href: post_path(post)
      end
      it "他人の投稿は表示されない" do
        expect(page).not_to have_link "", href: user_path(other_user)
        expect(page).not_to have_content other_post.title
      end
    end

    context "サイドバーの確認" do
      it "自分の名前が表示される" do
        expect(page).to have_content user.name
      end
      it "自分の紹介文が表示される" do
        expect(page).to have_content user.introduction
      end
      it "自分のユーザ編集画面へのリンクが存在する" do
        expect(page).to have_link "", href: edit_user_path(user)
      end
      it "ユーザー退会へのリンクが存在する" do
        expect(page).to have_link "退会する", href: users_withdraw_path(user)
      end
      it "プロフィール画像と投稿画像、王冠画像が表示される" do
        expect(all("img").size).to eq(3)
      end
    end
  end

  describe "投稿詳細画面のテスト" do
    before do
      visit post_path(post)
    end

    context "表示内容が正しい" do
      it "URLが正しい" do
        expect(current_path).to eq "/posts/" + post.id.to_s
      end
      it "「投稿詳細」と表示される" do
        expect(page).to have_content "投稿詳細"
      end
      it "名前のリンク先が正しい" do
        expect(page).to have_link post.user.name, href: user_path(post.user)
      end
      it "投稿のTitleが表示される" do
        expect(page).to have_content post.title
      end
      it "投稿のContentが表示される" do
        expect(page).to have_content post.content
      end
      it "投稿の編集リンクが表示される" do
        expect(page).to have_link "編集", href: edit_post_path(post)
      end
      it "投稿の削除リンクが表示される" do
        expect(page).to have_link "削除", href: post_path(post)
      end
    end

    context "編集リンクのテスト" do
      it "編集画面に遷移する" do
        click_link "編集"
        expect(current_path).to eq "/posts/" + post.id.to_s + "/edit"
      end
    end

    context "削除リンクのテスト" do
      before do
        click_link "削除"
      end

      it "正しく削除される" do
        expect(Post.where(id: post.id).count).to eq 0
      end
      it "リダイレクト先が、投稿一覧画面になっている" do
        expect(current_path).to eq "/posts"
      end
    end
  end

  describe "投稿編集画面のテスト" do
    before do
      visit edit_post_path(post)
    end

    context "表示内容が正しい" do
      it "URLが正しい" do
        expect(current_path).to eq "/posts/" + post.id.to_s + "/edit"
      end
      it "「投稿編集」と表示される" do
        expect(page).to have_content "投稿編集"
      end
      it "Title編集フォームが表示される" do
        expect(page).to have_field "post[title]", with: post.title
      end
      it "Content編集フォームが表示される" do
        expect(page).to have_field "post[content]", with: post.content
      end
      it "Tag編集フォームが表示される" do
        expect(page).to have_field "post[tag_ids]"
      end
      it "投稿更新ボタンが表示される" do
        expect(page).to have_button "投稿更新"
      end
    end

    context "編集成功のテスト" do
      i = 0
      before do
        i += 1
        @post_old_title = post.title
        @post_old_content = post.content
        @post_old_tag = post.tags if i == 1
        fill_in "post[title]", with: Faker::Lorem.characters(number: 10)
        fill_in "post[content]", with: Faker::Lorem.characters(number: 30)
        fill_in "post[tag_ids]", with: Faker::Lorem.characters(number: 2)
        click_button "投稿更新"
      end

      it "Titleが正しく更新される" do
        expect(post.reload.title).not_to eq @post_old_title
      end
      it "Contentが正しく更新される" do
        expect(post.reload.content).not_to eq @post_old_content
      end

      it "Tagが正しく更新される" do
        expect(post.tags).not_to eq @post_old_tag
      end
      it "リダイレクト先が、更新した投稿の詳細画面になっている" do
        expect(current_path).to eq "/posts/" + post.id.to_s
        expect(page).to have_content "投稿詳細"
      end
    end
  end

  describe "会員一覧画面のテスト" do
    before do
      visit users_path
    end

    context "表示内容の確認" do
      it "URLが正しい" do
        expect(current_path).to eq "/users"
      end
      it "「会員一覧」と表示される" do
        expect(page).to have_content "会員一覧"
      end
      it "自分と他人の画像が表示される" do
        expect(all("img").size).to eq(2)
      end
      it "自分と他人の名前がそれぞれ表示される" do
        expect(page).to have_content user.name
        expect(page).to have_content other_user.name
      end
      it "自分と他人のshowリンクがそれぞれ表示される" do
        expect(page).to have_link user.name, href: user_path(user)
        expect(page).to have_link other_user.name, href: user_path(other_user)
      end
      it "自分と他人の紹介文がそれぞれ表示される" do
        expect(page).to have_content user.introduction
        expect(page).to have_content other_user.introduction
      end
    end
  end

  describe "通知画面のテスト" do
    before do
      visit notifications_path
    end

    context "表示内容が正しい" do
      it "URLが正しい" do
        expect(current_path).to eq "/notifications"
      end
      it "「通知」と表示されている" do
        expect(page).to have_content "通知"
      end
    end
  end

  describe "退会画面のテスト" do
    before do
      visit users_withdraw_path(user)
    end

    context "表示内容が正しい" do
      it "URLが正しい" do
        expect(current_path).to eq "/users/withdraw/" + user.id.to_s
      end
      it "「退会画面」と表示されている" do
        expect(page).to have_content "退会画面"
      end
      it "退会しないのリンクが表示されている" do
        expect(page).to have_content "退会しない"
      end
      it "退会するのリンクが表示されている" do
        expect(page).to have_content "退会する"
      end
    end

    context "リンクの確認" do
      it "退会しないへのリンク先が正しい" do
        expect(page).to have_link "退会しない", href: user_path(user)
      end
      it "退会するへのリンク先が正しい" do
        expect(page).to have_link "退会する", href: user_path(user.id)
      end
    end
  end

  describe "フォロワー一覧画面のテスト" do
    before do
      visit user_followers_path(user)
    end

    context "表示内容が正しい" do
      it "URLが正しい" do
        expect(current_path).to eq "/users/" + user.id.to_s + "/followers"
      end
      it "「フォロワー」と表示されている" do
        expect(page).to have_content "フォロワー"
      end
    end
  end

  describe "フォロー一覧の画面のテスト" do
    before do
      visit user_followings_path(user)
    end

    context "表示内容が正しい" do
      it "URLが正しい" do
        expect(current_path).to eq "/users/" + user.id.to_s + "/followings"
      end
      it "「フォロー中」と表示されている" do
        expect(page).to have_content "フォロー中"
      end
    end
  end
end
