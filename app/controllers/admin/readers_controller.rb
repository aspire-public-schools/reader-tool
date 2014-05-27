class Admin::ReadersController < ApplicationController

  def create
    reader = Reader.new(params[:reader])
    if reader.save
      redirect_to admin_readers_path, :flash => { :success => "Your changes were saved!" }
    else
      render new_admin_reader_path, :flash => { :error => "Check your fields"}
    end
  end

  def new
    @reader = Reader.new
  end

  def index
    @readers = Reader.all
  end

  def edit
    @readers = Reader.all
  end

  def show
    @readers = Reader.all
  end

end
