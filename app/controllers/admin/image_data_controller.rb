class Admin::ImageDataController < ApplicationController
  before_filter :authenticate_user!

  # GET /image_data
  # GET /image_data.json
  def index
    @image_data = ImageDatum.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @image_data }
    end
  end

  # GET /image_data/1
  # GET /image_data/1.json
  def show
    @image_datum = ImageDatum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @image_datum }
    end
  end

  # GET /image_data/new
  # GET /image_data/new.json
  def new
    @image_datum = ImageDatum.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @image_datum }
    end
  end

  # GET /image_data/1/edit
  def edit
    @image_datum = ImageDatum.find(params[:id])
  end

  # POST /image_data
  # POST /image_data.json
  def create
    @image_datum = ImageDatum.new(params[:image_datum])

    respond_to do |format|
      if @image_datum.save
        format.html { redirect_to admin_image_datum_path(@image_datum), notice: 'Image datum was successfully created.' }
        format.json { render json: @image_datum, status: :created, location: @image_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @image_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /image_data/1
  # PUT /image_data/1.json
  def update
    @image_datum = ImageDatum.find(params[:id])

    respond_to do |format|
      if @image_datum.update_attributes(params[:image_datum])
        format.html { redirect_to admin_image_datum_path(@image_datum), notice: 'Image datum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @image_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /image_data/1
  # DELETE /image_data/1.json
  def destroy
    @image_datum = ImageDatum.find(params[:id])
    @image_datum.destroy

    respond_to do |format|
      format.html { redirect_to admin_image_data_url }
      format.json { head :no_content }
    end
  end
end
