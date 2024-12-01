class AddRatingAndParentAndLikesCountToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :rating, :integer, null: true
    add_column :reviews, :parent_id, :integer, null: true
    add_column :reviews, :likes_count, :integer, default: 0, null: false
	add_index :reviews, :parent_id
  end
end
