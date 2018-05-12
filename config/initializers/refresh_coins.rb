
puts "starting initializer"

Thread.new do

  RefreshCoinsJob.perform_now

end
