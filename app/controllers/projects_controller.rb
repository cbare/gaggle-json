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
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to(@project, :notice => 'Project was successfully created.') }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
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
    doc = JSON.parse(request.raw_post)
    db["documents"].save(doc)
    @project.document_ids << doc["_id"]
    @projects.save()
    render :json => @project
  end

  # PUT /projects/1/documents/456
  def addDocument
    @project = Project.find(params[:id])
    doc_id = BSON::ObjectId.from_string(params[:doc_id])
    db = MongoMapper.database
    doc = db["documents"].find_one( { '_id' => doc_id } )
    @project.document_ids << doc_id
    @projects.save()
    render :json => @project
  end

  # DELETE /projects/1/documents/456
  def removeDocument
    @project = Project.find(params[:id])
    @projects.document_ids.remove(params[:doc_id])
    render :json => @project
  end

end
