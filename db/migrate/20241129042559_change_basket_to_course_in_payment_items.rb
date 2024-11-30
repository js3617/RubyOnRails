class ChangeBasketToCourseInPaymentItems < ActiveRecord::Migration[6.0]
  def change
    # basket_id 제거
    remove_reference :payment_items, :basket, foreign_key: true

    # course_id 추가
    add_reference :payment_items, :course, null: false, foreign_key: true
  end
end