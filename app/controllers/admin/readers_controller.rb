class Admin::ReadersController < ApplicationController

  def create
    @reader = Reader.new(params[:reader])
    if @reader.save
      redirect_to admin_readers_path, :flash => { :success => "Your changes were saved!" }
    else
      flash[:error] = "#{@reader.errors.full_messages.to_sentence}."
      render :new
    end
  end

  def new
    @reader = Reader.new
  end


  def index
    @readers = Reader.all.sort
  end

  def edit
    @reader = Reader.find(params[:id])
    # @reader_name = Reader.all
    # @pagetitle = "Edit #{@reader.first_name} #{@reader.last_name}"
  end

  def update
    @reader = Reader.find(params[:id])
    if @reader.update_attributes(params[:reader])
      flash[:success] = "Godzilla says #{@reader.first_name} #{@reader.last_name} was Updated"
      redirect_to admin_readers_path
    else
      flash[:error] = "#{@reader.errors.full_messages.to_sentence}."
      render :edit
    end
  end

  def deactivate
    @reader = Reader.find(params[:id])
    if @reader.update_attributes(is_reader1a: "0", is_reader1b: "0", is_reader2: "0")
      flash[:success] = "Godzilla says #{@reader.first_name} #{@reader.last_name} was deactivated"
    else
      flash[:error] = "Mothra defeats Godzilla, try again!"
    end
    redirect_to admin_readers_path
  end

  def show
    @reader = Reader.find(params[:id])
  end

end
