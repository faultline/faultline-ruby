module Faultline
  class AsyncSender < Airbrake::AsyncSender
    def initialize(config)
      @config = config
      @unsent = SizedQueue.new(config.queue_size)
      @sender = SyncSender.new(config)
      @closed = false
      @workers = ThreadGroup.new
      @mutex = Mutex.new
      @pid = nil
    end
  end
end
