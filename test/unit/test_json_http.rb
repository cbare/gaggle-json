require 'test_helper'
require 'uri'
require 'net/http'


class TestRestAPI < ActiveSupport::TestCase
  
  def setup
    @host = "localhost"
    @port = 3000
  end

  def test_add_namelist
    url = URI.parse("http://#{@host}:#{@port}/documents/4da60f351ff236120b000003")
    res = Net::HTTP.get url
    namelist = JSON.parse(res)
    assert namelist['name'] == 'RNA polymerase genes'
    assert namelist['type'] == 'namelist'
    assert namelist['metadata']['species'] == 'Halobacterium salinarum NRC-1'
    assert namelist.has_key? "gaggle-data"
    genes = namelist['gaggle-data']
    ["VNG2662G", "VNG2664G", "VNG2665G", "VNG2666G", "VNG2668G"].each {|gene| assert genes.include? gene}
    assert genes.length==5
  end

  def test_add_matrix
  end

  def test_add_network
  end

  def test_add_table
  end

  def test_add_tuple
  end


  def test_update_namelist
  end


  def test_delete_object
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
