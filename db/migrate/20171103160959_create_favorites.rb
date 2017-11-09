class CreateFavorites < ActiveRecord::Migration[5.1]
  def change
    create_table :favorites do |t|
      t.references :micropost, foreign_key: true #user_idカラム
      t.references :user, foreign_key: true #micropost_idカラム

      t.timestamps
    end
  end
end
