
puts "starting GetErcDataJob initializer"

Thread.new do


    GetErcDataJob.perform_now
end
