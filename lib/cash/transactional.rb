module Cash
  class Transactional
    attr_reader :memcache

    def initialize(memcache, lock)
      @memcache, @cache = [memcache, memcache]
      @lock = lock
      @transition_caches = ThreadsafeHash.new
    end

    def transaction
      exception_was_raised = false
      begin_transaction
      result = yield
    rescue Object => e
      exception_was_raised = true
      raise
    ensure
      begin
        current_cache.flush unless exception_was_raised
      ensure
        end_transaction
      end
    end

    def method_missing(method, *args, &block)
      current_cache.send(method, *args, &block)
    end

    def respond_to?(method)
      current_cache.respond_to?(method)
    end

    private
    def begin_transaction
      @transition_caches[transition_cache_key] = Buffered.push(current_cache, @lock)
    end

    def end_transaction
      @transition_caches[transition_cache_key] = @transition_caches[transition_cache_key].pop
      if @transition_caches[transition_cache_key] == @cache
        @transition_caches.delete(transition_cache_key)
      end
    end

    def current_cache
      @transition_caches[transition_cache_key] || @cache
    end

    def transition_cache_key
      Thread.current.object_id
    end
  end
end
