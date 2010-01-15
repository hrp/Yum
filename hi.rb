require 'rubygems'
require 'sinatra'
require 'haml'
require 'truveo'

get '/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end

get '/search' do
  @query = params[:query]
  @results = search_truveo(@query)
  
  @results.video_set.each do |vid|
    vid['thumbnailUrl'] = vid['thumbnailUrlLarge'] if !vid['thumbnailUrlLarge'].nil?
  end

  haml :search
end

get '/*' do
  @query = "Daft Punk"
  @results = search_truveo(@query)
  haml :search
end

def search_truveo(*query)
  t = Truveo.new("08f3e5e3670ce918d")
  query = "nfl:season_type=POST" if query.nil?
  return t.get_videos(query)
end
  