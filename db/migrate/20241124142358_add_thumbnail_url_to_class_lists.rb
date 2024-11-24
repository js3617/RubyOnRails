class AddThumbnailUrlToClassLists < ActiveRecord::Migration[6.0]
  def change
    add_column :class_lists, :thumbnail_url, :string
  end
end
