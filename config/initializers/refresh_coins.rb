
puts "starting refresh_coins initializer"


Thread.new do


  while true do
    RefreshCoinsJob.perform_now
    sleep(10.minutes)
  end
    
end
