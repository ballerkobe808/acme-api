
puts "starting initializer"

Thread.new do

  # perform a refresh of the coins every half hour
  while true do
    RefreshCoinsJob.perform_now
    sleep(30.minutes)
  end
end
