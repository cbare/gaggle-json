require 'test_helper'
require 'uri'
require 'net/http'


class TestRestAPI < ActiveSupport::TestCase
  
  def setup
    @host = "localhost"
    @port = 3000
    @objects_added = []
  end

  def test_get_namelist
    url = URI.parse("http://#{@host}:#{@port}/documents/4da60f351ff236120b000003")
    response = Net::HTTP.get url
    namelist = JSON.parse(response)
    assert namelist['name'] == 'RNA polymerase genes'
    assert namelist['type'] == 'namelist'
    assert namelist['metadata']['species'] == 'Halobacterium salinarum NRC-1'
    assert namelist.has_key? "gaggle-data"
    expected_genes = ["VNG2662G", "VNG2664G", "VNG2665G", "VNG2666G", "VNG2668G"]
    namelist['gaggle-data'].each {|gene| assert expected_genes.include? gene}
    assert namelist['gaggle-data'].length==5
  end

  def test_get_namelist2
    namelist = _get_gaggle_data_object("4da60f351ff236120b000003")
    assert namelist['name'] == 'RNA polymerase genes'
    assert namelist['type'] == 'namelist'
    assert namelist['metadata']['species'] == 'Halobacterium salinarum NRC-1'
    assert namelist.has_key? "gaggle-data"
    expected_genes = ["VNG2662G", "VNG2664G", "VNG2665G", "VNG2666G", "VNG2668G"]
    namelist['gaggle-data'].each {|gene| assert expected_genes.include? gene}
    assert namelist['gaggle-data'].length==5
  end


  def _get_gaggle_data_object(id)
    # a hash holding HTTP headers
    headers = { "Content-Type" => "application/json", "Accept"=>"application/json" }

    # do the HTTP POST request, passing the namelist as JSON and the HTTP headers
    response = Net::HTTP.start(@host, @port) do |http|
      http.request_get("/documents/#{id}", headers)
    end
    
    if (response.is_a? Net::HTTPNotFound)
      return nil
    end

    # show response body
    p "content-type = #{response['content-type']}"
    p response.body
    p response.inspect

    # response should be JSON
    assert response['content-type'].match( /application\/json/ )
    
    return JSON.parse(response.body)
  end

  def _post_gaggle_data_object(data)
    # a hash holding HTTP headers
    headers = { "Content-Type" => "application/json", "Accept"=>"application/json" }
  
    # do the HTTP POST request, passing the namelist as JSON and the HTTP headers
    response = Net::HTTP.start(@host, @port) do |http|
      http.request_post('/documents', data.to_json, headers)
    end
  
    # show response body
    p response['content-type']
    p response.body
  
    # response should be JSON
    assert response['content-type'].match( /application\/json/ )
  
    # make sure our object was given an ID by the server
    response_json = JSON.parse(response.body)
    assert response_json.has_key? "_id"
    p "id = #{response_json["_id"]}"
  
    return response_json["_id"]
  end

  def _update(data, id=nil)
    # a hash holding HTTP headers
    headers = { "Content-Type" => "application/json", "Accept"=>"application/json" }

    # if we're given an ID use it, otherwise see if there's one in the data object
    if id==nil
      id = data['_id']
    end

    # do the HTTP POST request, passing the namelist as JSON and the HTTP headers
    response = Net::HTTP.start(@host, @port) do |http|
      http.send_request('PUT', "/documents/#{id}", data.to_json, headers)
    end

    # show response body
    p response['content-type']
    p response.body

    # response should be JSON
    assert response['content-type'].match( /application\/json/ )
  end

  # def test_add_namelist
  #   namelist = {  "name"=>"test names", 
  #                 "type"=>"namelist",
  #                 "metadata"=>{"species"=>"Monkey", "timestamp"=>Time.now.to_s},
  #                 "gaggle-data"=>["foo", "bar", "bat", "boo"] }
  #   _post_gaggle_data_object(namelist)
  # end
  # 
  # def test_add_matrix
  #   matrix = {  "name"=>"test matrix",
  #               "type"=>"matrix",
  #               "metadata"=>{"species"=>"guanaco", "timestamp"=>Time.now.to_s},
  #               "gaggle-data"=>{ 
  #                 "row names"=>["foo", "bar", "bat", "boo"],
  #                 "columns"=>[
  #                   {
  #                     "name"=>"condition1",
  #                     "values"=>[0.01,0.02,0.03,0.04]
  #                   },
  #                   {
  #                     "name"=>"condition1",
  #                     "values"=>[0.01,0.02,0.03,0.04]
  #                   }]
  #                 }
  #             }
  #   _post_gaggle_data_object(matrix)
  # end
  # 
  # def test_add_network
  #   network = { "name"=>"test network",
  #               "type"=>"network",
  #               "metadata"=>{"species"=>"Alces alces", "timestamp"=>Time.now.to_s},
  #               "gaggle-data"=>{ 
  #                 "nodes"=>[ {"node"=>"foo"}, {"node"=>"bar"}, {"node"=>"bat"}, {"node"=>"boo"} ],
  #                 "edges"=>[
  #                   {"source"=>"foo", "target"=>"bar", "interaction"=>"my interaction"},
  #                   {"source"=>"foo", "target"=>"bat", "interaction"=>"my interaction"},
  #                   {"source"=>"bat", "target"=>"bar", "interaction"=>"my interaction"},
  #                   {"source"=>"foo", "target"=>"boo", "interaction"=>"my interaction"}
  #                 ]
  #               }
  #             }
  #   _post_gaggle_data_object(network)
  # end
  # 
  # def test_add_table
  #   table = { "name"=>"test table",
  #             "type"=>"table",
  #             "metadata"=>{"species"=>"Baboon", "timestamp"=>Time.now.to_s},
  #             "gaggle-data"=>{ 
  #               "columns"=> [
  #                 {
  #                   "name"=>"gene name",
  #                   "values"=>["foo", "bar", "bat", "boo", "bonk"]
  #                 },
  #                 {
  #                   "name"=>"sequence",
  #                   "values"=>["chromosome", "chromosome", "chromosome", "plasmid X123", "plasmid X123"]
  #                 },
  #                 {
  #                   "name"=>"strand",
  #                   "values"=>['+','+','-','+','-']
  #                 },
  #                 {
  #                   "name"=>"start",
  #                   "values"=>[101234,101678,102987,3456,3999]
  #                 },
  #                 {
  #                   "name"=>"end",
  #                   "values"=>[101567,102789,103333,3888,4567]
  #                 }
  #               ]
  #             }
  #           }
  #   _post_gaggle_data_object(table)
  # end
  # 
  # def test_add_tuple
  #   tuple = { "name"=>"test table",
  #             "type"=>"table",
  #             "metadata"=>{"species"=>"Banana", "timestamp"=>Time.now.to_s},
  #             "gaggle-data"=>{
  #               "name"=>"Christopher",
  #               "shoe-size"=>11,
  #               "IQ"=>12,
  #               "bozo"=>true
  #             }
  #           }
  #   _post_gaggle_data_object(tuple)
  # end
  
  
  def test_update_namelist
    # create and store a list of fruits
    fruits = {
      "name"=>"fruits",
      "type"=>"namelist",
      "metadata"=>{"timestamp"=>Time.now.to_s},
      "gaggle-data"=>["watermelon", "cantaloupe", "peach", "blueberry"]
    }
    id = _post_gaggle_data_object(fruits)

    # read saved fruits
    fruits2 = _get_gaggle_data_object(id)

    # add a new fruit
    fruits2["gaggle-data"] << "rambutan"

    # save that back to the db
    _update(fruits2)

    # read again from the db
    fruits3 = _get_gaggle_data_object(id)

    # check if result is what we expected
    assert fruits3['type'] == 'namelist'
    assert fruits3['gaggle-data'].length == 5
    expected_fruits = ["watermelon", "cantaloupe", "peach", "blueberry", "rambutan"]
    assert fruits3.has_key? "gaggle-data"
    fruits3['gaggle-data'].each {|fruit| assert expected_fruits.include? fruit}

    @objects_added << id
  end

  def test_delete_object
    # create and store a list of fruits
    fruits = {
      "name"=>"fruits",
      "type"=>"namelist",
      "metadata"=>{"timestamp"=>Time.now.to_s},
      "gaggle-data"=>["watermelon", "cantaloupe", "peach", "pickle"]
    }
    id = _post_gaggle_data_object(fruits)

    # a hash holding HTTP headers
    headers = { "Content-Type" => "application/json", "Accept"=>"application/json" }

    # do the HTTP POST request, passing the namelist as JSON and the HTTP headers
    response = Net::HTTP.start(@host, @port) do |http|
      http.send_request('DELETE', "/documents/#{id}", nil, headers)
    end

    # read from the db
    p "----*----" * 10
    fruits2 = _get_gaggle_data_object(id)
    p "----%----" * 10

    p fruits2.inspect
  end

  def test_create_and_add_to_project
  end

  def test_update_into_project
  end


  def test_add_to_project
  end

  def test_remove_from_project
  end
end
