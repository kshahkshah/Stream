class EmailStream < Stream
  
  def initialize(*args)
    super
    @email = args.first
  end

  def parse!
    # Iterate over attachments, and create stream elements from them
    puts "Parsing attachments..." if verbose?
    @email.attachments.each do |attachment|

      element = new_element_from_attachment(attachment)

      {
        :location     => parse_for_location,
        :subject      => @email.subject.value,
        :description  => parse_for_description,
        :keyword      => parse_for_keywords,
        :ip           => parse_for_ip_list,
        :sent_from    => parse_for_sent_from
      }.each_pair do |tag,value|
        element.send "#{tag.to_s}_list=", value if value
      end
      
      if element.save
        puts "Element saved..." if verbose?
      else
        puts "Failed to save element..."
        puts element.errors
      end
      
      cleanup_temp_file(attachment.filename)

      puts "Done..." if verbose?
    end
  end

  private
  
    def parse_for_ip_list
      received_array = @email.received.map(&:value)
      received_array = received_array.map{|x| x.match /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/}
      received_array.compact.map(&:to_s).join(",")
    end
  
    def parse_for_location
      debugger
      nil
    end

    def parse_for_description
      debugger
      nil      
    end

    def parse_for_keywords
      debugger
      nil
    end

    def parse_for_sent_from
      debugger
      nil
    end
  
    def cleanup_temp_file(filename)
      puts "Cleaning up tmp files..." if verbose?
      File.delete("/tmp/#{filename}")
    end
  
    def new_element_from_attachment(attachment)
      # Create the file twice until you can do it directly within Paperclip
      file = File.open("/tmp/#{attachment.filename}", 'w+')
      file.write(attachment.decoded)

      puts "Initializing an element..." if verbose?
      Element.new({:attachment => file})
    end

end