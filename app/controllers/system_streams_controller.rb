class SystemStreamsController < ApplicationController
  include ActionController::Live

  def show
  end

  def events
    response.headers["Content-Type"] = "text/event-stream"
    system('mkdir pippo')
    3.times {
      response.stream.write "data: Hello, browser!...\n\n"
      sleep 2
    }
  rescue IOError
    logger.error "Stream error"
  ensure
    response.stream.close
    logger.info "Stream closed"
  end

  def index
  end

end
