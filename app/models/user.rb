# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  name                   :string
#  admin                  :boolean          default(FALSE), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JWTBlacklist

  has_one_attached :avatar

  has_many :tasks, dependent: :delete_all
  has_many :logs, dependent: :delete_all
  has_many :notes, dependent: :delete_all
  has_many :nodes, foreign_key: :reporter_id
  has_many :favorites, dependent: :delete_all
  has_many :invitations, dependent: :delete_all
  has_many :memberships, dependent: :delete_all
  has_many :projects, through: :memberships
  has_many :comments
  has_many :assignments, class_name: "Assignee", dependent: :delete_all
  
  def attributes
    { id: id, email: email, admin: admin, name: name }
    # TODO: include the user avatar url
  end

  # TODO
  # Use SQL to make it pretty and fast
  def accessible_projects
    owned_projects = Node.where(ancestry: nil, reporter: self).pluck(:id)
    belong_projects = memberships.pluck(:node_id)
    all_projects = (owned_projects + belong_projects).uniq
    
    Node.where(id: all_projects)
  end

  def active_invitations
    invitations.where(declined: false, accepted: false).map(&:attach_label)
  end
end
