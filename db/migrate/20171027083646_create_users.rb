class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end

#（password_digest）パスワードを平文でデータベースに保存すべきではない。
#開発者側で個人のパスワードが見れてしまったり万が一どこかにその情報が漏れてしまったとき個人のパスワードが完全にバレてしまう。
#セキュリティの観点から、データベースにパスワードを保存するときには必ずダイジェストで（暗号化して）保存する。