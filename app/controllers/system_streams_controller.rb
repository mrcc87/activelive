class SystemStreamsController < ApplicationController
  include ActionController::Live

  def show
  end

  def events
    response.headers["Content-Type"] = "text/event-stream"
    pipe = IO.popen("ls -1")
    while(line = pipe.gets)
      response.stream.write "data: #{line}\n\n"
      sleep 0.5
    end
  rescue IOError
    logger.error "Stream error"
  ensure
    pipe.close
    response.stream.close
    logger.info "Stream closed"
  end

  def index
  end

end
