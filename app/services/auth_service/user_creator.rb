class AuthService
  class UserCreator
    def self.build
      new
    end

    def call(user_data)
      user = User.find_by_fbid(user_data[:fbid])
      if user.nil?
        user = User.create!(user_data)
      else
        user.update_attributes!(user_data.slice(:name, :avatar_url))
      end
      user
    rescue ActiveRecord::RecordInvalid => e
      raise ::AuthService::AuthenticationFailed, e
    end
  end
end
