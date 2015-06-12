class User < Sequel::Model
  one_to_many :posts
end

class Post < Sequel::Model
  many_to_one :user
  many_to_one :place
end

class Topic < Sequel::Model
  one_to_many :subjects
end

class Subject < Sequel::Model
  many_to_one :topic
  one_to_many :places
end

class Place < Sequel::Model
  many_to_one :subject
  one_to_many :posts
end