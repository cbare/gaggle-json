module GaggleDataHelper
  def get_data_type(gaggle_data_object)
    if gaggle_data_object["gaggle-data"].has_key? "namelist" then
      return "namelist"
    elsif gaggle_data_object["gaggle-data"].has_key? "matrix" then
      return "matrix"
    elsif gaggle_data_object["gaggle-data"].has_key? "network" then
      return "network"
    elsif gaggle_data_object["gaggle-data"].has_key? "tuple" then
      return "tuple"
    elsif gaggle_data_object["gaggle-data"].has_key? "table" then
      return "table"
    end
    return "unknown"
  end
end
