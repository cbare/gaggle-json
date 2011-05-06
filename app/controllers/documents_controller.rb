require 'json'

class DocumentsController < ApplicationController

  # GET /documents
  def index
    db = MongoMapper.database
    if request.raw_post.strip.length > 0 then
      query = JSON.parse(request.raw_post)
      if query.has_key? "_id"
        query['_id'] = BSON::ObjectId.from_string(query['_id'])
      elsif query.has_key? "id"
        query['_id'] = BSON::ObjectId.from_string(query['id'])
        query.delete 'id'
      end
      docs = db["documents"].find( query )
    else
      docs = db["documents"].find()
    end
    result = []
    docs.each do |doc|
      entry = { "_id" => doc["_id"] }
      if doc.has_key? "name"
        entry["name"] = doc["name"]
      end
      if doc.has_key? "type"
        entry["type"] = doc["type"]
      end
      result << entry
    end
    render :json => result
  end

  # GET /documents/12345678
  def show
    id = BSON::ObjectId.from_string(params[:id])
    db = MongoMapper.database
    doc = db["documents"].find_one( { '_id' => id } )
    if (doc==nil)
      render :text=>"document #{id} not found ", :status => 404
      return
    end
    render :json => doc
  end

  # POST /documents
  # caller can specify a project for this to be added to
  def create
    begin
      db = MongoMapper.database
      doc = JSON.parse(request.raw_post)
      project_id = doc.delete("project_id")
      db["documents"].save(doc)
      _add_to_project_if_specified(doc, project_id)
      render :json => doc
    rescue Exception => e
      render :text => "Exception: #{e}\n"
    end
  end

  # PUT /documents/12345678
  # caller can specify a project for this to be added to
  def update
    id = BSON::ObjectId.from_string(params[:id])
    db = MongoMapper.database
    doc = JSON.parse(request.raw_post)
    doc["_id"] = id
    project_id = doc.delete("project_id")
    db["documents"].update( { '_id' => id }, doc, {:upsert  => true} )
    _add_to_project_if_specified(doc, project_id)
    render :json => doc
  end

  # DELETE /documents/12345678
  def destroy
    id = BSON::ObjectId.from_string(params[:id])
    db = MongoMapper.database
    db["documents"].remove({'_id' => id})
    head :ok, :location => "/documents/#{params[:id]}"
  end

  # add a document to a project, if it's not already a member
  def _add_to_project_if_specified(doc, project_id)
    if (project_id)
      project = Project.find(doc["project_id"])
      if (project && !project.document_ids.include?(doc["_id"]))
        project.document_ids << doc_id
        project.save()
      end
    end
  end

end
