class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :characters, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def display_name
    email_address.to_s.split("@", 2).first
      .tr("._-", " ")
      .squish
      .presence
      &.titleize || "Aventureiro"
  end

  def initials
    display_name.split.filter_map(&:first).first(2).join.upcase
  end
end
