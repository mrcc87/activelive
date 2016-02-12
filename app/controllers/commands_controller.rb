class CommandsController < ApplicationController
  include ActionController::Live
  before_action :set_command, only: [:show, :edit, :update, :destroy]

  def index
    @commands = Command.all
  end

  def show
    $redis.set("command", "#{@command.line}")
    @command
  end

  def new
    @command = Command.new
  end

  def edit
  end

  def create
    @command = Command.new(command_params)
    if @command.save
      redirect_to @command, notice: 'Command was successfully created.'
    else
      render :new
    end
  end

  def update
    if @command.update(command_params)
      redirect_to @command, notice: 'Command was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @command.destroy
    redirect_to commands_url, notice: 'Command was successfully destroyed.'
  end

  private
  def set_command
    @command = Command.find(params[:id])
  end

  def command_params
    params.require(:command).permit(:line)
  end
end
