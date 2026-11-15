require 'net/http'

m4v_path = []
m4a_path = []
live_id = ARGV[0]

puts 'Usage: Download www.instagram.com.har and exec ruby insta_live_realtime_downloader.rb <init filename except `-0-init.*`>'
puts Dir.pwd

File.readlines("#{Dir.pwd}/www.instagram.com.har", chomp: true).each do | line |
  if line.chomp.include?(ARGV[0])
    trimmed_line = line.gsub('"url": "', '').gsub('",', '')
    unless start_time == 0
      trimmed_timing = File.basename(trimmed_line).split('_')[1].split('_')[0].to_i
      next if trimmed_timing < start_time || trimmed_timing > end_time
    end
    m4v_path.push(trimmed_line.strip) if trimmed_line.include?('m4v')
    m4a_path.push(trimmed_line.strip) if trimmed_line.include?('m4a')
  end
end

File.write("#{Dir.pwd}/downlist_video.txt", '# File list of video')
File.write("#{Dir.pwd}/downlist_audio.txt", '# File list of audio')

m4v_path.each do | path |
  curl_down_path = "#{Dir.pwd}/ts/#{File.basename(path).split('?')[0]}"
  curl_result = `curl -o #{curl_down_path} #{path}`
  File.write("#{Dir.pwd}/downlist_video.txt", "\nfile #{curl_down_path}", mode: 'a')
end

m4a_path.each do | path |
  curl_down_path = "#{Dir.pwd}/ts/#{File.basename(path).split('?')[0]}"
  curl_result = `curl -o #{curl_down_path} #{path}`
  File.write("#{Dir.pwd}/downlist_video.txt", "\nfile #{curl_down_path}", mode: 'a')
end

# system('ffmpeg -f concat -safe 0 -i downlist_video.txt -c copy video.mp4')
# system('ffmpeg -f concat -safe 0 -i downlist_audio.txt -c copy audio.mp4')
# system('ffmpeg -i video.mp4 -i audio.mp4 -c:v copy -c:a aac output.mp4')
# system('rm -rf downlist_video.txt downlist_audio.txt video.mp4 audio.mp4 ts/* www.instagram.com.har')
