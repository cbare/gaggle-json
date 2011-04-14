class ExampleController < ApplicationController

  def namelist
    # example_id = BSON::ObjectId.from_string("4da60f351ff236120b000003")
    # db = MongoMapper.database
    # @doc = db["documents"].find_one( { '_id' => example_id } )
    @page_title = "Gaggle-JSON Namelist"
    @example_id = "4da60f351ff236120b000003"
    @example = File.foreach("public/examples/namelist.json").collect().join("")
  end

  def matrix
    @page_title = "Gaggle-JSON Matrix"
    @example_id = "4da60fd51ff236120b000004"
    @example = File.foreach("public/examples/matrix.json").collect().join("")
  end

  def network
    @page_title = "Gaggle-JSON Network"
    @example_id = "4da612601ff236120b000005"
    @example = File.foreach("public/examples/network.json").collect().join("")
  end

  def tuple
    @page_title = "Gaggle-JSON Tuple"
    @example_ids = ["4da613a91ff236120b000006", "4da613c71ff236120b000007", "4da613fc1ff236120b000008"]
    @examples = []
    @examples << File.foreach("public/examples/tuple.node.attributes.json").collect().join("")
    @examples << File.foreach("public/examples/tuple.cluster.json").collect().join("")
    @examples << File.foreach("public/examples/tuple.command.json").collect().join("")
  end

  def table
    @page_title = "Gaggle-JSON Table"
    @example_id = "4da614391ff236120b000009"
    @example = File.foreach("public/examples/table.json").collect().join("")
  end

end
