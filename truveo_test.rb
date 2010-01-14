require 'truveo'

query = "football"

t = Truveo.new("08f3e5e3670ce918d")
results = t.get_videos(query)

#results.video_set[1].each_key do |i|
#	p i
#end
a = 1
results.video_set.each do |vid|
  p vid
  p a	  
  a += 1
end
