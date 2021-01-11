# frozen_string_literal: true

class ChangeFollowingNextCursorColumnTypeForUsers < ActiveRecord::Migration[6.1]
  def up
    change_column :users, :following_next_cursor, :string, default: "-1"
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "カラムの型をintegerに変更できません"
  end
end
