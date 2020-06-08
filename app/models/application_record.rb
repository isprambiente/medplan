# frozen_string_literal: true

# This model contain the methods shared for all models
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # return an unique string identifier from class name and object id
  # @example @user.div -> 'user_12'
  # @return [String]
  def div
    [self.class.to_s, '_', id].join.downcase
  end
end
