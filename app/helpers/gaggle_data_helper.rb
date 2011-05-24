module GaggleDataHelper

  class PrettyJson
    attr_accessor :json

    def initialize(indent_level=0)
      @indent_level = indent_level
      @json = ""
    end

    def indent
      if (json[-1,1] == "\n")
        return " " * @indent_level
      else
        return " "
      end
    end

    def _pp_hash(obj)
      json << indent << "{\n"
      @indent_level += 1
      first = true
      for key in obj.keys do
        if (first)
          first = false
        else
          json << ",\n"
        end
        json << indent << key.to_s << ":"
        _pretty_print_json(obj[key])
      end
      json << "\n"
      @indent_level -= 1
      json << indent << "}"
    end

    def _pp_array(obj)
      json << indent << "[\n"
      @indent_level += 1
      first = true
      obj.each do |element|
        if (first)
          first = false
        else
          json << ",\n"
        end
        _pretty_print_json(element)
      end
      json << "\n"
      @indent_level -= 1
      json << indent << "]"
    end

    def _pp_obj(obj)
      json << indent << obj.to_json
    end

    def _pretty_print_json(obj)
      if obj.is_a? Hash then
        _pp_hash(obj)
      elsif obj.is_a? Array then
        _pp_array(obj)
      else
        _pp_obj(obj)
      end
    end
    
    def pretty_print_json(obj)
      _pretty_print_json(obj)
      json << "\n"
      return json
    end
  end

  def GaggleDataHelper.pretty_print_json(obj)
    return PrettyJson.new().pretty_print_json(obj)
  end
  
  def GaggleDataHelper.size(table)
    if table["type"] == "table" || table["type"] == "matrix" then
      cols = table["gaggle-data"]["columns"].length
      if (cols > 0)
        rows = table["gaggle-data"]["columns"][0]["values"].length
      else
        rows = 0
      end
      return "#{rows} rows by #{cols} columns"
    elsif table["type"] == "namelist"
      return table["gaggle-data"].length
    elsif table["type"] == "network"
      nodes = table["gaggle-data"]["nodes"].length
      edges = table["gaggle-data"]["edges"].length
      return "#{nodes} nodes and #{edges} edges"
    elsif table["type"] == "tuple"
      return table["gaggle-data"].keys.length
    end
  end

  def GaggleDataHelper.rowCount(table)
    if table["type"] == "table" || table["type"] == "matrix" then
      cols = table["gaggle-data"]["columns"].length
      if (cols > 0)
        rows = table["gaggle-data"]["columns"][0]["values"].length
      else
        rows = 0
      end
      return rows
    end
  end

  def GaggleDataHelper.colCount(table)
    if table["type"] == "table" || table["type"] == "matrix" then
      return table["gaggle-data"]["columns"].length
    end
    return 0
  end

  def GaggleDataHelper.toCytoscapeWebNetwork(network)
    result = { 'nodes'=>[], 'edges'=>[] }
    network['gaggle-data']['nodes'].each do |node|
      new_node = {'id'=>node['node'], 'label'=>node['node']}
      result['nodes'] << new_node
    end
    i = 0
    network['gaggle-data']['edges'].each do |edge|
      new_edge = {'id'=>"e#{i}"}
      new_edge['source'] = edge['source']
      new_edge['target'] = edge['target']
      new_edge['interaction'] = edge['interaction']
      result['edges'] << new_edge
      i += 1
    end
    return result.to_json
  end

  def GaggleDataHelper.matrixToJSONbyRows(matrix)
    columns = matrix['gaggle-data']['columns']
    row_count = GaggleDataHelper.rowCount(matrix)
    result = '['
    if row_count > 0
      row = []
      for i in 0...columns.length
        puts("====columns====#{columns[i].inspect}")
        row << columns[i]['values'][0]
      end
      result << '[' << row.join(",") << ']'
      
      for r in 1...row_count
        row = []
        for i in 0...columns.length
          row << columns[i]['values'][r]
        end
        result << ",\n" << '[' << row.join(",") << ']'
      end
    end
    result << ']'
    puts("~"*100)
    puts()
    puts("~"*100)
    return result
  end

end
