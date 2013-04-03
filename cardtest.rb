#!/usr/bin/ruby
cardspecs = [
              {:spec => "AMEX", :start => [34,37], :length => 15},
              {:spec => "Discover", :start => [6011], :length => 16},
              {:spec => "MasterCard", :start => 51..55, :length => 16},
              {:spec => "Visa", :start => [4], :length => 16}
            ]

cards = ["4111111111111111","4111111111111","4012888888881881","378282246310005","6011111111111117","5105105105105100","5105 1051 0510 5106","9111111111111111"]

CARD_FINAL_STATUS = ["valid","invalid"]

cards.each do |card_number|
  
  card_type = "Unknown"
  card_validity = ""
  checksum = 0
  
  card_number.gsub!(" ","")

  cardspecs.each do |spec|
    spec[:start].each do |start|
      
      # does it match a valid start pattern?
      next unless card_number.match(/^#{start}/)

      card_type = spec[:spec]

      # does it match a valid length?
      unless card_number.length == spec[:length]
        card_validity = "invalid"
        break
      end

      # does it have a valid checksum?
      card_number.split("").reverse.each_with_index do |digit, index|
        check_digit = index % 2 == 0 ? digit.to_i : (digit.to_i * 2).to_s.split("").map(&:to_i).inject{|sum,x| sum += x.to_i}
        checksum += check_digit
      end

      unless checksum % 10 == 0
        card_validity = "invalid"
      else
        card_validity = "valid"
      end
      
      break
    end
    
    break if CARD_FINAL_STATUS.include?card_validity
  end
  
  card_validity = "invalid" unless card_validity == "valid"
  
  puts "#{card_type}: #{card_number} (#{card_validity})"
end