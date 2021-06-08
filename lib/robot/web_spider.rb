require 'rest-client'
require 'logger'

module Robot
  class WebSpider
    attr_accessor :url, :headers, :proxy, :retry_limit,
                  :logger, :need_cache, :cache

    def initialize(host, options = {})
      @host = host
      @config = options
      @port = config[:port]
      if @port.nil? || @port == 80
        @url = @host
      else
        # FIXME: xx.com/feed -> xx.com:8000/feed
        @url = @host + ':' + @port.to_s
      end

      @headers = config[:headers]
      @headers[:cookie] = config[:cookies] if config[:cookies]

      @proxy = config[:proxy]
      @retry_limit = config[:retry_limit]
      @need_cache = config[:need_cache]
      @cache = config[:cache]
      @logger = Logger.new("#{Rails.root}/log/" + config[:log_path])
    end

    # 获取网页源数据
    def fetch
      logger.info("[+] Begin to parse #{self.class}: #{url}")

      if need_cache && cache.fetch(url)
        cache.fetch(url)
      else
        retry_count = 0

        begin
          # TODO: proxy是全局的，需要隔离独立每个实例
          RestClient.proxy = @proxy
          response = RestClient.get(url, headers).body
          cache.write(url, response, expires_in: 60.minutes) if need_cache
          logger.info("pdd web spider:" + response.inspect)
        rescue SocketError => e
          # 无法连接： 域名错误、端口错误
          logger.error(e)
          raise FetchException
        rescue Errno::ECONNREFUSED => e
          # 连接被拒绝
          logger.error(e)
          raise FetchException
        rescue RestClient::NotFound => e
          # 无法找到页面
          logger.error(e)
          raise FetchException
        rescue => e
          logger.error(e)
          logger.info("[+] Retry #{retry_count} times")

          retry_count += 1
          retry if retry_count <= retry_limit

          raise RetryTooManyTimeException
        end

        logger.info("[+] End to parse #{self.class}: #{url}")

        response
      end
    end

    # 处理网页源数据
    # def handle(response)
    #   raise "handle 是个抽象方法，需要在子类中实现"
    # end

    private

    def default_config
      {
          headers: {
              user_agent: 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Mobile Safari/537.36'
          },
          retry_limit: 3,
          log_path: "#{self.class}.log",
          need_cache: true,
          cache: Rails.cache
      }
    end

    def config
      default_config.merge(@config.compact)
    end

    def parse_cookies(cookies)
      return {} if cookies.nil?
      cookies_hash = {}
      cookies.split(';').map do |cookie|
        cookie.scan(/(.+?)=(.+)/)
        cookies_hash[$1.strip] = $2.strip
      end
      cookies_hash
    end

    class WebSpiderException < RuntimeError
    end

    class NotFoundException < WebSpiderException
    end

    class FetchException < WebSpiderException
    end

    class ParseException < WebSpiderException
    end

    class RetryTooManyTimeException < WebSpiderException
    end
  end
end
