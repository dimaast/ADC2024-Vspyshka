class AddJtiToUsers < ActiveRecord::Migration[6.1]
  require "securerandom"

  def up
    # 1) Добавить колонку nullable
    add_column :users, :jti, :string

    # 2) Сгенерировать уникальный JTI для каждого уже существующего пользователя
    say_with_time "Backfilling jti for existing users" do
      # Сбросить кэш схемы, чтобы ActiveRecord узнал о новой колонке
      User.reset_column_information
      User.find_each do |user|
        # записываем прямо в базу минуя валидации
        user.update_column(:jti, SecureRandom.uuid)
      end
    end

    # 3) Сделать NOT NULL и добавить уникальный индекс
    change_column_null    :users, :jti, false
    add_index            :users, :jti, unique: true
  end

  def down
    remove_index :users, :jti
    remove_column :users, :jti
  end
end
