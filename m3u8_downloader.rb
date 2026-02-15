url=''
filename=''

ARGV.each do |arg|
  url = arg[0]
  filename = arg[1]
end

def download_via_ffmpeg(url, filename)
  system("ffmpeg -i #{url}-bsf:a_aac_adtstoasc -c copy #{filename}.mp4")
end

download_via_ffmpeg(url, filename)