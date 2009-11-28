class Element < ActiveRecord::Base
  
  has_attached_file :attachment, :styles => { :large => "600x600>" }
  acts_as_taggable_on :location, :subject, :description, :keywords, :ip, :sent_from, :batch

  def tags?
    tags.any?
  end
  
  def tags
    @tags ||= join(taggings.map(&:context).uniq.map{|x| send "#{x}_list"}.flatten)
  end
  
  def name
    subject_list.any? ? join(subject_list) : attachment_file_name
  end
  
  def location
    location_list.any? ? join(location_list) : "somewhere"
  end
  
  protected
    def join(list)
      list.join(", ")
    end

end
