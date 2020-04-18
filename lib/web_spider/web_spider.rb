require 'rest-client'
require 'logger'
require 'json'

class WebSpider
  attr_accessor :url, :headers, :proxy, :retry_limit,
                :logger, :need_cache, :cache

  def initialize(url, options = {})
    @url = url
    @config = options

    @headers = config[:headers]
    @proxy = config[:proxy]
    @retry_limit = config[:retry_limit]
    @need_cache = config[:need_cache]
    @cache = config[:cache]
    @logger = Logger.new("#{Rails.root}/log/" + config[:log_path])
  end

  # 主入口
  # 1. 获取网页数据
  # 2. 处理数据
  # 3. 转换成系统想要的格式
  def parse
    logger.info("[+] Begin to scapy : #{url}")
    response = fetch
    data = handle(response)
    result = transform_data(data)
    logger.info("[+] End to scapy : #{url}")
    result
  end

  # 获取网页源数据
  def fetch
    if need_cache && cache.fetch(url)
      cache.fetch(url)
    else
      retry_count = 0

      begin
        RestClient.proxy = config[:proxy] if config[:proxy]
        response = RestClient.get(url, headers).body
        cache.write(url, response, expires_in: 60.minutes) if need_cache
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
      response
    end
  end

  # 处理网页源数据
  def handle(response)
    # raise "handle 是个抽象方法，需要在子类中实现"
    response
  end

  # 把数据转化成系统需要的格式
  def transform_data(data)
    data
  end

  private

  def default_config
    {
        headers: {
            user_agent: 'Mozilla\u002F5.0 (Windows NT 6.1; Win64; x64) AppleWebKit\u002F537.36 (KHTML, like Gecko) Chrome\u002F72.0.3626.121 Safari\u002F537.36'
        },
        retry_limit: 3,
        log_path: "#{self.class}.log",
        need_cache: false,
        cache: Rails.cache
    }
  end

  def config
    default_config.merge(@config)
  end

  class WebSpiderException < RuntimeError
  end

  class NotFoundException < WebSpiderException
  end

  class FetchException < WebSpiderException
  end

  class ParseException < WebSpiderException
  end

  class RetryTooManyTimeExcepiton < WebSpiderException
  end
end