require 'bluecloth'

class MarkdownController < ApplicationController

  def show
    contents = File::read( params[:file] )
    bc = BlueCloth::new( contents )
    render :layout => 'layouts/application.html.erb', :text => bc.to_html
  end

end