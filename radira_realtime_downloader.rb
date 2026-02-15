if !ARGV || ARGV.length < 2
  puts 'Usage: ruby radira_realtime_downloader.rb $running_time_in_minutes $first_aac_file_url_of_broadcast'
  return
end

estimated_length_min = ARGV[0]
nhk_aac_url = ARGV[1]
aac_filename_first = File.basename(nhk_aac_url, '.aac')
aac_name_prefix = aac_filename_first.split('_')[0]
aac_start_num = aac_filename_first.split('_')[1].to_i
number_of_files = estimated_length_min.to_i * 6 # min * 60 / 10 (aac length = 10s)

number_of_files.times do |n|
  cur_num = aac_start_num + n
  aac_filename = "#{aac_name_prefix}_#{cur_num.to_s.rjust(5, '0')}.aac"
  system("curl -O #{File.dirname(nhk_aac_url)}/#{aac_filename}") # net/http cannot write files directly
  system('sleep 10') # aac length = 10s
end

aac_path = Dir.glob('*.aac').sort

File.write('downlist_radira.txt', '# File list of aac')

aac_path.each do | path |
  curl_down_path = File.basename(path)
  File.write('downlist_radira.txt', "\nfile #{curl_down_path}", mode: 'a')
end

system('ffmpeg -f concat -safe 0 -i downlist_radira.txt -c copy radira_output.aac')
system('ffmpeg -i radira_output.aac -acodec libmp3lame radira_output.mp3')
system('rm -rf downlist_radira.txt *.aac')