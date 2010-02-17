require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
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
    # vid['thumbnailUrl'] = vid['thumbnailUrlLarge'] if !vid['thumbnailUrlLarge'].nil?
    vid['dateFound'] = Time.parse(vid['dateFound']).strftime('%I:%M%p %b %d, %Y')
    vid_time = Time.parse(vid['dateFound'])
    vid['dateFound'] = vid_time.strftime('%I:%M%p').downcase.gsub(/^0/, '')
    vid['dateFound'] << vid_time.strftime(' %b %d, %Y')
    vid['runtime'] = (vid['runtime'].to_i / 60).to_s + ':' + (vid['runtime'].to_i % 60).to_s if vid['runtime']
    
    
    # vid['description'].gsub!(@query, '<strong>#{@query}</strong>') unless vid['description'].nil?
    # vid['title'].gsub!(@query, '<strong>#{@query}</strong>')
    
  end

  haml :search
end

get '/*' do
  @query = "Daft Punk"
  @query = nil
  # @results = search_truveo(@query)
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