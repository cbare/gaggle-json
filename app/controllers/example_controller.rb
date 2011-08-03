class ExampleController < ApplicationController

  def namelist
    @page_title = "Gaggle-JSON Namelist"
    @example_id = "4da60f351ff236120b000003"
    @example = File.foreach("public/examples/namelist.json").collect().to_a().join("")
  end

  def matrix
    @page_title = "Gaggle-JSON Matrix"
    @example_id = "4da60fd51ff236120b000004"
    @example = File.foreach("public/examples/matrix.json").collect().to_a().join("")
  end

  def network
    @page_title = "Gaggle-JSON Network"
    @example_id = "4da612601ff236120b000005"
    @example = File.foreach("public/examples/network.json").collect().to_a().join("")
  end

  def tuple
    @page_title = "Gaggle-JSON Tuple"
    @example_ids = ["4da613a91ff236120b000006", "4da613c71ff236120b000007", "4da613fc1ff236120b000008"]
    @examples = []
    @examples << File.foreach("public/examples/tuple.node.attributes.json").collect().to_a().join("")
    @examples << File.foreach("public/examples/tuple.bicluster.json").collect().to_a().join("")
    @examples << File.foreach("public/examples/tuple.command.json").collect().to_a().join("")
  end

  def table
    @page_title = "Gaggle-JSON Table"
    @example_id = "4da614391ff236120b000009"
    @example = File.foreach("public/examples/table.json").collect().to_a().join("")
  end
  
  def document
    @example_id = BSON::ObjectId.from_string(params[:id])
    db = MongoMapper.database
    @doc = db["documents"].find_one( { '_id' => @example_id } )
    @example = GaggleDataHelper.pretty_print_json(@doc)
    if (@doc.has_key? "type")
      @type = @doc["type"]
    else
      @type = "JSON document"
    end

    # JSON.pretty_generate doesn't want to work for mongo docs. It seems not to
    # like the BSON ID field. Strangely, it gives thie error:
    # undefined method `merge' for #<JSON::Ext::Generator::State:0x104481700>
    # @example = JSON.pretty_generate(@doc)
  end

end
