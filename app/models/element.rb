class Element < ActiveRecord::Base
  
  has_attached_file :attachment, :styles => { :large => "600x600>" }

end
