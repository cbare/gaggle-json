module JsonHtmlHelper

  class JsonToHtml
    attr_accessor :json

    def initialize()
      @json = ""
    end

    def _pp_hash(obj)
      json << "<ul>\n"
      for key in obj.keys do
        json << "<li>" << key.to_s << " : "
        _to_html(obj[key])
        json << "</li>\n"
      end
      json << "</ul>\n"
    end

    def _pp_array(obj)
      json << "<ul>\n"
      obj.each do |element|
        json << "<li>"
        _to_html(element)
        json << "</li>\n"
      end
      json << "</ul>\n"
    end

    def _pp_obj(obj)
      json << obj.to_s
    end

    def _to_html(obj)
      if obj.is_a? Hash then
        _pp_hash(obj)
      elsif obj.is_a? Array then
        _pp_array(obj)
      else
        _pp_obj(obj)
      end
    end
    
    def to_html(obj)
      _to_html(obj)
      return json
    end
  end

  def JsonHtmlHelper.json_to_html(obj)
    return JsonToHtml.new().to_html(obj)
  end

end
