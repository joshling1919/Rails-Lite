require 'erb'
require 'byebug'

class ShowExceptions
  attr_reader :app
  def initialize(app)
    @app = app
  end

  def call(env)
    byebug
    write_log(env)
    app.call(env)
  end

  private

  def render_exception(e)
    log_file = File.open('application.log', 'a')
    log_text =  <<-LOG
    TIME: #{Time.now}
    IP: #{env['REMOTE_ADDR']}
    PATH: #{env['REQUEST_PATH']}
    ____________________________\n
    LOG

    log_file.write(log_text)
    log_file.close
  end

end
