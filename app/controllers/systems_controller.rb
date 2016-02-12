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
    logger.info command.inspect
    if command.first
      response.stream.write "data: #{command.first}\n\n"
    end
  rescue IOError
    logger.error "AN ERROR HAS OCCURED..."
  ensure
    logger.info "quitting redis"
    redis_cli.quit
    logger.info "closing stream"
    response.stream.close
  end
end
