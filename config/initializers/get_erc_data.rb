
puts "starting GetErcDataJob initializer"

Thread.new do


  # perform a refresh of the coins erc20 every 4 hours
  while true do
    GetErcDataJob.perform_now
    sleep(4.hours)
  end
    
end
