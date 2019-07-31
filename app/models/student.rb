class Student < User
  has_many :help_requests
  has_many :chats
end
