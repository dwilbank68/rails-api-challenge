class RenameColumnTypeInMonstersToType < ActiveRecord::Migration
  def change
    rename_column :monsters, :type, :_type
  end
end
