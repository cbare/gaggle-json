require 'json'

class DocumentsController < ApplicationController

  # GET /documents/12345678
  def show
    db = MongoMapper.database
    doc = db["documents"].find_one( { '_id' => BSON::ObjectId.from_string(params[:id]) } )
    render :json => doc
  end

  # POST /documents
  def create
    db = MongoMapper.database
    doc = JSON.parse(request.raw_post)
    db["documents"].insert(doc)
    render :json => doc
  end

  # PUT /documents/12345678
  def update
    db = MongoMapper.database
    doc = JSON.parse(request.raw_post)
    db["documents"].save(doc)
    render :json => doc
  end

  # DELETE /documents/12345678
  def destroy
    db = MongoMapper.database
    db["documents"].remove(BSON::ObjectId.from_string(params[:id]))
    head :ok, :location => "/documents/#{params[:id]}"
  end

end
