class Stream

  def self.open(*args)
    stream = if args.first.class.eql?(Mail::Message)
      EmailStream.new(*args)
    end
    
    stream.parse!      
  end
  
  def initialize(*args)
    @options = args.last
  end
  
  def verbose?
    !!@options[:verbose]
  end

end