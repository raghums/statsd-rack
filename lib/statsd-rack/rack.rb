require "statsd-rack/version"
require "statsd-ruby"

module StatsdRack
  
  class Rack
    REQUEST_METHOD = 'REQUEST_METHOD'.freeze
    VALID_METHODS = ['GET', 'HEAD', 'POST', 'PUT', 'DELETE'].freeze

    # Initializes the middleware
    # 
    # prefix    -    String prefix for Statsd key.
    #                Defaults to 'rack'
    #
    def initialize(app, prefix=nil)
      @app = app
      stats_prefix = prefix || 'rack'
      @track_gc = GC.respond_to?(:time)
      if !$statsd
        $statsd = ::Statsd.new('localhost', 9125).tap{|sd| sd.namespace = stats_prefix}
      end
    end

    # called after request is processed.
    def record_request(status, env)
      now = Time.now
      diff = (now - @start)

      if $statsd
        $statsd.timing("response_time", diff * 1000)
        if VALID_METHODS.include?(env[REQUEST_METHOD])
          stat = "response_time.#{env[REQUEST_METHOD].downcase}"
          $statsd.timing(stat, diff * 1000)
        end

        if suffix = status_suffix(status)
          $statsd.increment "status_code.#{status_suffix(status)}"
        end
        if @track_gc && GC.time > 0
          $statsd.timing "gc.time", GC.time / 1000
          $statsd.count  "gc.collections", GC.collections
        end
      end

    rescue => boom
      warn "Statsd::Rack#record_request failed: #{boom}"
    end

    def status_suffix(status)
      suffix = case status.to_i
        when 200 then :ok
        when 201 then :created
        when 202 then :accepted
        when 301 then :moved_permanently
        when 302 then :found
        when 303 then :see_other
        when 304 then :not_modified
        when 305 then :use_proxy
        when 307 then :temporary_redirect
        when 400 then :bad_request
        when 401 then :unauthorized
        when 402 then :payment_required
        when 403 then :forbidden
        when 404 then :missing
        when 410 then :gone
        when 422 then :invalid
        when 500 then :error
        when 502 then :bad_gateway
        when 503 then :node_down
        when 504 then :gateway_timeout
      end
    end

    # Refer: https://github.com/github/rack-statsd/blob/master/lib/rack-statsd.rb
    #
    # Body wrapper. Yields to the block when body is closed. This is used to
    # signal when a response is fully finished processing.
    class Body
      def initialize(body, &block)
        @body = body
        @block = block
      end

      def each(&block)
        if @body.respond_to?(:each)
          @body.each(&block)
        else
          block.call(@body)
        end
      end

      def close
        @body.close if @body.respond_to?(:close)
        @block.call
        nil
      end
    end

    def call(env)
      @start = Time.now
      GC.clear_stats if @track_gc
      status, headers, body = @app.call(env)
      body = Body.new(body) { record_request(status, env) }
      [status, headers, body]
    end
  end
end
