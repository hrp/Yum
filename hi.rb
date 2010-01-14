require 'rubygems'
require 'sinatra'
require 'haml'
require 'truveo'

get '/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass:stylesheet
end

get '/search' do
  t = Truveo.new("08f3e5e3670ce918d")
  @results = t.get_videos(params[:query])
  
  
  @results.video_set.each do |vid|
      if !vid['thumbnailUrlLarge'].nil?
        vid['thumbnailUrl'] = vid['thumbnailUrlLarge']
      end
    end
  
  @query = params[:query]
  haml :search
end

get '/*' do
  haml:index
end