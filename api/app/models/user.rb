require "mongoid"
module Sentinel
  class User
    include Mongoid::Document
    include Mongoid::Timestamps::Created
    include Mongoid::Timestamps::Updated
    include ActiveModel::SecurePassword


    field :email, type: String
    field :first_name, type: String
    field :last_name, type: String
    field :password_digest, :type => String
    field :domain, type: String

    has_secure_password validations: true

    validates :first_name, presence: true
    validates :last_name, presence: true

    has_many :checks
    has_many :integrations

  end
end
