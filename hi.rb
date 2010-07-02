require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'truveo'

require 'yaml'
CONFIG = YAML::load(File.open('keys.yaml'))
p CONFIG

get '/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end

get '/search' do
  @query = params[:query]
  @query_modified = params[:query_modified]
  @page  = params[:page]
  @page  = 1 if @page.nil?
  if @query_modified
    full_query = @query + ' ' + @query_modified
  else
    full_query = @query
  end
  p full_query
  @results = search_truveo(full_query, @page)
  
  @results.video_set.each do |vid|
    vid['thumbnailUrl'] = vid['thumbnailUrlLarge'] if !vid['thumbnailUrlLarge'].nil?
    p vid['dateFound']
    p vid
    vid_time = Time.parse(vid['dateFound'])
    vid['dateFound'] = vid_time.strftime('%I:%M%p').downcase.gsub(/^0/, '').downcase
    vid['dateFound'] << vid_time.strftime(' %b %d, %Y')
    if vid['runtime']
      minutes = (vid['runtime'].to_i / 60)
      seconds = (vid['runtime'].to_i % 60)
      minutes = minutes > 0 ? minutes.to_s + " min" : ""
      seconds = seconds > 0 ? seconds.to_s + " sec" : ""
      vid['runtime'] = (minutes + " " + seconds).chomp
    end
    
    
    
    # vid['description'].gsub!(@query, '<strong>#{@query}</strong>') unless vid['description'].nil?
    # vid['title'].gsub!(@query, '<strong>#{@query}</strong>')
    
  end

  haml :search
end

get '/*' do
  @query, @results = nil, nil
  haml :search
end


def search_truveo(query, page=1, page_size=10)
  t = Truveo.new(CONFIG['truveo-key'])
  # query = "nfl:season_type=POST" if query.nil?
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