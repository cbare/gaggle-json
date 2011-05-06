class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.xml
  def index
    @projects = Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])
    db = MongoMapper.database
    @documents = db["documents"].find( { "_id" => { "$in" => @project.document_ids} } )

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project] || JSON.parse(request.body.read))

    respond_to do |format|
      if @project.save
        format.html { redirect_to(@project, :notice => 'Project was successfully created.') }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
        format.json { render :text => "json create project" }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
        format.json { render :text => "json create project error" }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes!(params[:project])
        format.html { redirect_to(@project, :notice => 'Project was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end

  # POST /projects/1/documents
  def addNewDocument
    @project = Project.find(params[:id])
    if (@project == nil)
      render :text => "project #{params[:id]} not found"
    else
      doc = JSON.parse(request.raw_post)
      db = MongoMapper.database
      db["documents"].save(doc)
      doc_id = doc[:_id]
      if (doc_id)
        @project.document_ids << doc[:_id]
        @project.save()
        render :json => @project
      else
        render :text => "couldn't assign doc id?"
      end
    end
  end

  # PUT /projects/1/documents/456
  def addDocument
    @project = Project.find(params[:id])
    if (@project == nil)
      render :text => "project #{params[:id]} not found"
    else
      doc_id = BSON::ObjectId.from_string(params[:doc_id])
      db = MongoMapper.database
      doc = db["documents"].find_one( { '_id' => doc_id } )
      if doc
        @project.document_ids << doc_id
        @project.save()
      end
      render :json => @project
    end
  end

  # DELETE /projects/1/documents/456
  def removeDocument
    @project = Project.find(params[:id])
    if (@project == nil)
      render :text => "project #{params[:id]} not found"
    else
      doc_id = BSON::ObjectId.from_string(params[:doc_id])
      @project.document_ids.delete(doc_id)
      @project.save()
      render :json => @project
    end
  end

end
