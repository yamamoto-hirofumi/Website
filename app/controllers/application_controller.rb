class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :count_login_history
  before_action :continuous_login

  def after_sign_in_path_for(resource)
    posts_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  private

  # 連続ログインで動くメソッド
  def continuous_login
    if current_user
      array_desc = current_user.login_histories.order(logind_at: "desc")
      array_asc = current_user.login_histories.order(logind_at: "asc")
      unless current_user.login_histories.last.flashd_at.try(:to_date) == Date.today
        if current_user
          first_day = ""
          # ログインした日取得しループさせる
          array_desc.each_with_index do |login_history, index|
            # ログインが連続しているかを確認している。indexで比較している為、最新のログイン日に来ればループ終了。nil対策。
            if array_desc.last.logind_at.to_date == login_history.logind_at.to_date
              first_day = login_history.logind_at.to_date
              break
            end
            # ログインした一番新しい日ー１つ前のログインした日を取得して１より大きければ
            if (login_history.logind_at.to_date - array_desc[index + 1].
                logind_at.to_date).to_int > 1
              first_day = login_history.logind_at.to_date
              break
            end
          end

          num = 1
          # first_dayから今日までのlogind_atを取得しループさせる
          current_user.login_histories.where(logind_at: first_day..array_asc.last.logind_at).
            order(logind_at: "asc").each_with_index do |login_history, index|
            # ログインが連続しているかの確認。indexで比較している為、最新のログイン日に来ればループ終了。nil対策。
            if array_asc.last.logind_at.to_date == login_history.logind_at.to_date
              break
            end
            if (array_asc[index + 1].logind_at.to_date - login_history.logind_at.to_date).
                to_int == 1
              num += 1
            end
          end
          flash[:notice] = num.to_s + "日連続ログインおめでとうございます(^_^)今日も1日楽しみましょう！！"
          current_user.login_histories.last.update(flashd_at: DateTime.now)
        end
      end
    end
  end

  # ログイン記録を作成する
  def count_login_history
    if current_user
      if current_user.login_histories.present?
        # 再ログインしても記録されない
        unless current_user.login_histories.order(logind_at: "asc").
            last.logind_at.to_date == Date.today
          current_user.login_histories.create(logind_at: DateTime.now)
        end
      else
        current_user.login_histories.create(logind_at: DateTime.now)
      end
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
