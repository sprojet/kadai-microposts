class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.references :user, foreign_key: true
      t.references :follow, foreign_key: { to_table: :users }
     # user_id というカラム名が被ってしまうので、 follow_id にしている。
      t.timestamps

      t.index [:user_id, :follow_id], unique: true
      #user_id と follow_id のペアで重複するものが保存されないようにするデータベースの設定
    end
  end
end
