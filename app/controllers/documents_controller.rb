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
  # caller can specify a project for this to be added to
  def create
    db = MongoMapper.database
    doc = JSON.parse(request.raw_post)
    project_id = doc.delete("project_id")
    db["documents"].save(doc)
    _add_to_project_if_specified(doc, project_id)
    render :json => doc
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
