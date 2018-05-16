
puts "starting refresh_coins initializer"

Thread.new do

    RefreshCoinsJob.perform_now

end
