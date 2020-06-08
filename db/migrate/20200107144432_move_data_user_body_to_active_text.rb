# frozen_string_literal: true

# This migration update content field with body values
class MoveDataUserBodyToActiveText < ActiveRecord::Migration[6.0]
  def change
    User.where.not(body: '').find_each do |user|
      user.content = user.body
      user.save if user.valid?
    end
  end
end
