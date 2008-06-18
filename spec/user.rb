class User < ActiveRecord::Base
  named_scope :married, :conditions => {:married => true}
end
