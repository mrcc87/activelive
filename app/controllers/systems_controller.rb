class SystemsController < ApplicationController
  include ActionController::Live
  def run
    response.headers["Content-Type"] = "text/event-stream"
    logger.info "Starting run"
    redis_cli = Redis.new
    #redis_cli.subscribe("command") do |on|
    #  logger.info redis_cli.inspect
    #  on.message do |event, data|
    #    logger.info data.inspect
    #    logger.info event.inspect
    #    response.stream.write "data: #{data}\n\n"
    #  end
    #end
    #
    command = redis_cli.multi do |multi|
      multi.get("command")
      multi.del("command")
    end
    pipe = IO.popen
    logger.info command.inspect
    ex = command.first
    if ex
      pipe(ex)
      while(line = pipe.gets)
        response.stream.write "data: #{line}\n\n"
        sleep 0.5
      end
    end
  rescue IOError
    logger.error "AN ERROR HAS OCCURED..."
  ensure
    pipe.close unless pipe.nil?
    logger.info "quitting redis"
    redis_cli.quit
    logger.info "closing stream"
    response.stream.close
  end
end
