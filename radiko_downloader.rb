require 'net/http'

aac_path = []
start_time = ARGV[0].to_i || 0
end_time = ARGV[1].to_i || 0

puts Dir.pwd

File.readlines("#{Dir.pwd}/radiko.jp.har", chomp: true).each do | line |
  if line.chomp.end_with?('.aac",')
    trimmed_line = line.gsub('"url": "', '').gsub('",', '')
    unless start_time == 0
      trimmed_timing = File.basename(trimmed_line).split('_')[1].split('_')[0].to_i
      next if trimmed_timing < start_time || trimmed_timing > end_time
    end
    aac_path.push(trimmed_line.strip)
  end
end

File.write("#{Dir.pwd}/downlist_radiko.txt", '# File list of aac')

aac_path.each do | path |
  curl_down_path = "#{Dir.pwd}/ts/#{File.basename(path)}"
  curl_result = `curl -o #{curl_down_path} #{path}`
  File.write("#{Dir.pwd}/downlist_radiko.txt", "\nfile #{curl_down_path}", mode: 'a')
end

system('ffmpeg -f concat -safe 0 -i downlist_radiko.txt -c copy radiko_output.aac')
system('ffmpeg -i radiko_output.aac -acodec libmp3lame radiko_output.mp3')
system('rm -rf downlist_radiko.txt radiko_output.aac ts/* radiko.jp.har')