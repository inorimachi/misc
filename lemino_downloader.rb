require 'net/http'

v_path = []
a_path = []
puts Dir.pwd
File.readlines("#{Dir.pwd}/lemino.docomo.ne.jp.har", chomp: true).each do | line |
  if line.chomp.end_with?('.m4s",')
    trimmed_line = line.gsub('"url": "', '').gsub('",', '')
    v_path.push(trimmed_line.strip) if trimmed_line.include?('video_5934522')
    a_path.push(trimmed_line.strip) if trimmed_line.include?('audio_103103')
  end
end

v_path.each do  | path |
    curl_down_path = "#{Dir.pwd}/ts/video/#{File.basename(path)}"
    curl_result = `curl -o #{curl_down_path} #{path}`
    File.write("#{Dir.pwd}/ts/video/init.mp4", File.read(curl_down_path), mode: 'a')
  end

a_path.each do | path |
  curl_down_path = "#{Dir.pwd}/ts/#{File.basename(path)}"
  curl_result = `curl -o #{curl_down_path} #{path}`
  File.write("#{Dir.pwd}/ts/audio/init.mp4", File.read(curl_down_path), mode: 'a')
end

system('ffmpeg -decryption_key 9ba5e786f7d8b42e559e4f5c7aedca2d -i ts/video/init.mp4 -c:v copy video.mp4')
system('ffmpeg -decryption_key 9ba5e786f7d8b42e559e4f5c7aedca2d -i ts/audio/init.mp4 -c:a copy audio.m4a')
system('ffmpeg -i video.mp4 -i audio.mp4 -c:v copy -c:a copy output.mp4')
# system('rm -rf downlist_lemino_v.txt downlist_lemino_a.txt radiko_output.aac ts/video/* ts/audio/* lemino.docomo.ne.jp.har')
