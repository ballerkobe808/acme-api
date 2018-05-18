
puts "starting refresh_coins initializer"


Thread.new do


  # do a pull of the coin data every 10 minutes. There are a couple of other ways to
  # go about looping thru the list of calls, other options are in the job itself
  while true do
    RefreshCoinsJob.perform_now
    sleep(10.minutes)
  end
    
end
