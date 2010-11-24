
module Cash
  class ThreadsafeHash
    def initialize
      @read_store, @write_store = {}, {}
      @mutex = Mutex.new
    end
    
    def [](key)
      @read_store[key]
    end
    
    def []=(key, value)
      atomic_send(:[]=, key, value)
    end

    def clear
      atomic_send(:clear)
    end
    
    def delete(id)
      atomic_send(:delete, id)
    end
    
    private
    def atomic_send(method_name, *args)
      @mutex.synchronize do
        @write_store.send(method_name, *args)
        @read_store, @write_store = @write_store, @read_store
        @write_store.send(method_name, *args)
      end
    end
  end
end
