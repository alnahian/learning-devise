class User < ActiveRecord::Base

  # setup attr_accessor
  attr_accessor :signin
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:signin]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :signin, :username, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  

  
  validates :username, :uniqueness => {:case_sensitive => false}
  
    def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if signin = conditions.delete(:signin)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => signin.downcase }]).first
      else
        where(conditions).first
      end
    end
end
