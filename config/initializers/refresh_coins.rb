
puts "starting refresh_coins initializer"

Thread.new do

    RefreshCoinsJob.perform_now
    # RefreshCoinsDataJob.perform_now

end
