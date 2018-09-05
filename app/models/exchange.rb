class Exchange < ApplicationRecord

  def self.fetch?(name)
    exchange = Exchange.find_by(name: name)
    if exchange 
      if Time.now - exchange.created_at < 1.minute 
        return false
      end 
      exchange.delete
    end 
    return true
  end 

end
