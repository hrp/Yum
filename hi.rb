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
  @page  = params[:page]
  @page  = 1 if @page.nil?
  @results = search_truveo(@query, @page)
  
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

def search_truveo(query, page=1, page_size=10)
  t = Truveo.new("08f3e5e3670ce918d")
  query = "nfl:season_type=POST" if query.nil?
  page = 1 if page.nil?
  start =  (page.to_i * page_size.to_i) - 10
  return t.get_videos(query, page_size, start)
end


helpers do
  # Generate a link path for :href
  def l(*args)
    args.compact!
    query = args.pop if args.last.is_a?(Hash)
    path = env["SCRIPT_NAME"] + "/" + args.map { |a| escape(a) }.join("/")
    path << "?" << build_query(query) if query
    path
  end
end