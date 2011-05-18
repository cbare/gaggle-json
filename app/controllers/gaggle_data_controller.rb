
class GaggleDataController < ApplicationController

  # GET /namelist/12345678
  def show
    @id = BSON::ObjectId.from_string(params[:id])
    db = MongoMapper.database
    @doc = db["documents"].find_one( { '_id' => @id } )
    if @doc == nil
      render :text => "object #{@id} not found"
    else
      if (@doc.has_key?("metadata") && @doc["metadata"].has_key?("species"))
        @species = @doc["metadata"]["species"]
      else
        @species = nil
      end

      @size = GaggleDataHelper.size(@doc)

      if (@doc["type"] == "namelist")
        render :template => "gaggle_data/show.namelist.html.erb"

      elsif (@doc["type"] == "matrix")
        @row_count = GaggleDataHelper.rowCount(@doc)
        render :template => "gaggle_data/show.matrix.html.erb"

      elsif (@doc["type"] == "network")
        @node_count = @doc["gaggle-data"]["nodes"].length
        @edge_count = @doc["gaggle-data"]["edges"].length
        render :template => "gaggle_data/show.network.html.erb"

      elsif (@doc["type"] == "table")
        @row_count = GaggleDataHelper.rowCount(@doc)
        render :template => "gaggle_data/show.table.html.erb"

      elsif (@doc["type"] == "tuple")
        @tuple_html = JsonHtmlHelper.json_to_html(@doc["gaggle-data"])
        render :template => "gaggle_data/show.tuple.html.erb"

      else
        @json = GaggleDataHelper.pretty_print_json(@doc)
        if (@doc.has_key? "type")
          @type = @doc["type"]
        else
          @type = "JSON document"
        end

        render :template => "gaggle_data/show.html.erb"
      end
    end
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
    db["documents"].update( { '_id' => id }, doc )
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
