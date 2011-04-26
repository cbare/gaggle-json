require 'json'

class DocumentsController < ApplicationController

  # GET /documents/12345678
  def show
    id = BSON::ObjectId.from_string(params[:id])
    db = MongoMapper.database
    doc = db["documents"].find_one( { '_id' => id } )
    render :json => doc
  end

  # POST /documents
  def create
    db = MongoMapper.database
    doc = JSON.parse(request.raw_post)
    db["documents"].save(doc)
    render :json => doc
  end

  # PUT /documents/12345678
  def update
    id = BSON::ObjectId.from_string(params[:id])
    db = MongoMapper.database
    doc = JSON.parse(request.raw_post)
    doc["_id"] = id
    db["documents"].update( { '_id' => id }, doc, {:upsert  => true} )
    render :json => doc
  end

  # DELETE /documents/12345678
  def destroy
    id = BSON::ObjectId.from_string(params[:id])
    db = MongoMapper.database
    db["documents"].remove(id)
    head :ok, :location => "/documents/#{params[:id]}"
  end

end
