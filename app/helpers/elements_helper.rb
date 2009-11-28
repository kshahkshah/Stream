module ElementsHelper
  
  def display(element)
    image_tag element.attachment.url(:large)
  end
  
end
