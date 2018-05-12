
puts "starting initializer"

Thread.new do

  # while true

    RefreshCoinsJob.perform_now

    # wait a bit before starting again
    # sleep(10)
  # end
end
