module ApplicationHelper
  # def authenticate_admin!
  #   redirect_to root_path unless current_user.admin?
  # end

  # 加载 VUE 组件的 template 内容
  def import_partial(partial)
    # 把 template 内容去除空白字符拼成一行
    res = render(partial).split("\n").join('')
    raw(res)
  end

  def present(object, locals = nil, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, locals, self)
    yield presenter if block_given?
    presenter
  end

  def user_agent
    request.headers['HTTP_USER_AGENT']
  end

  def web_browser?
    device_platform =~ /Linux|Windows|Macintosh|X11/i
  end

  def mobile_browser?
    device_platform =~ /iOS|android/i
  end

  def device_platform
    UserAgent.parse(user_agent).platform
  end

  def render_device_path
    case device_platform
    when /Linux|Windows|Macintosh|X11/i
      'web'
    when /iOS|android/i
      'mobile'
    else
      'web'
    end
  end
end
