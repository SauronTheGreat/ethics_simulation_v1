class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :facilitator_group_id, :admin, :educator

  belongs_to :facilitator_group
  has_one :facilitator
  has_many :student_group_users, :dependent => :destroy

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates_format_of :first_name, :with => /\A[a-zA-Z]+\z/
  validates_format_of :last_name, :with => /\A[a-zA-Z]+\z/


  def full_name
    [first_name, last_name].join(" ")
  end

end
