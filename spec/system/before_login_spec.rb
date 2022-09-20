require "rails_helper"

RSpec.describe "ログイン前のテスト", type: :request do
  describe "ヘッダーのテスト" do
    before do
      visit root_path
    end

    context "表示内容の確認" do
      it "タイトルが表示されている" do
        expect(page).to have_content "Make enjoy life"
      end
      it "トップページへのリンクが表示されている" do
        expect(page).to have_content "トップページ"
      end
      it "サイト紹介のリンクが表示されている" do
        expect(page).to have_content "サイト紹介"
      end
      it "新規登録のリンクが表示されている" do
        expect(page).to have_content "新規登録"
      end
      it "ログインのリンクが表示されている" do
        expect(page).to have_content "ログイン"
      end
    end

    context "リンクの確認" do
      it "トップページへのリンク先が正しい" do
        expect(page).to have_link "トップページ", href: root_path
      end
      it "サイト紹介のリンク先が正しいる" do
        expect(page).to have_link "サイト紹介", href: about_path
      end
      it "新規登録のリンク先が正しい" do
        expect(page).to have_link "新規登録", href: new_user_registration_path
      end
      it "ログインのリンク先が正しい" do
        expect(page).to have_link "ログイン", href: new_user_session_path
      end
    end
  end

  describe "トップページ画面のテスト" do
    before do
      visit root_path
    end

    context "表示内容が正しい" do
      it "URLが正しい" do
        expect(current_path).to eq "/"
      end
      it "「Welcome to Make enjoy life」と表示される" do
        expect(page).to have_content "Welcome to Make enjoy life"
      end
      it "「いいねランキン」と表示される" do
        expect(page).to have_content "いいねランキング"
      end
    end
  end

  describe "サイト紹介画面のテスト" do
    before do
      visit about_path
    end

    context "表示内容が正しい" do
      it "URLが正しい" do
        expect(current_path).to eq "/about"
      end
      it "「サイト紹介」と表示される" do
        expect(page).to have_content "サイト紹介"
      end
    end
  end

  describe "新規登録画面のテスト" do
    before do
      visit new_user_registration_path
    end

    context "表示画像が正しい" do
      it "URLが正しい" do
        expect(current_path).to eq "/users/sign_up"
      end
      it "「新規登録」と表示される" do
        expect(page).to have_content "新規登録"
      end
      it "nameフォームが表示される" do
        expect(page).to have_field "user[name]"
      end
      it "emailフォームが表示される" do
        expect(page).to have_field "user[email]"
      end
      it "passwordフォームが表示される" do
        expect(page).to have_field "user[password]"
      end
      it "password_confirmationフォームが表示される" do
        expect(page).to have_field "user[password_confirmation]"
      end
      it "新規登録ボタンが表示される" do
        expect(page).to have_button "新規登録"
      end
    end

    context "新規登録成功のテスト" do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button '新規登録' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、投稿一覧になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/posts'
      end
    end
  end

  describe "ログイン画面のテスト" do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「ログイン」と表示される' do
        expect(page).to have_content 'ログイン'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
      it 'emailフォームは表示されない' do
        expect(page).not_to have_field 'user[name]'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/posts'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end
end
