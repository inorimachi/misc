require 'net/http'

n = 10609848
arr = []
limit = 0

v_addr_init = "https://scontent-itm1-1.cdninstagram.com/hvideo-frc-nha/_nc_cat-110/v/rASeBiSs9uMh-8k9MX2ywfcv2eDUjqTkWu88O8_87OYVbgQ/_nc_ohc-uyCGuC59WTEQ7kNvwFrSaj3/live-dash/dash-lp-pst-v/17876184243488447_0-init.m4v?ms=m_C&sc_t=1&ccb=2-4"
a_addr_init = "https://scontent-itm1-1.cdninstagram.com/hvideo-frc-nha/_nc_cat-110/v/rASeBiSs9uMh-8k9MX2ywfcv2eDUjqTkWu88O8_87OYVbgQ/_nc_ohc-uyCGuC59WTEQ7kNvwFrSaj3/live-dash/dash-lp-hd-a/17876184243488447_0-init.m4a?ms=m_C&sc_t=1&ccb=2-4"

init_video_result = `curl -o ts/video_init.m4v #{v_addr_init}`
init_audio_result = `curl -o ts/audio_init.mp4 #{a_addr_init}`

init_video_result_backup = `curl -o video_init.m4v #{v_addr_init}`
init_audio_result_backup = `curl -o audio_init.mp4 #{a_addr_init}`


Dir.mkdir('ts/video') if Dir.glob('ts/video').empty?
Dir.mkdir('ts/audio') if Dir.glob('ts/audio').empty?


while n > limit do
    puts "pushed timing: #{n.to_s}"
    arr.push(n)
    
    v_addr = "https://scontent-itm1-1.cdninstagram.com/hvideo-frc-nha/_nc_cat-110/v/rASeBiSs9uMh-8k9MX2ywfcv2eDUjqTkWu88O8_87OYVbgQ/_nc_ohc-uyCGuC59WTEQ7kNvwFrSaj3/live-dash/dash-lp-pst-v/17876184243488447_0-#{n}.m4v?ms=m_C&sc_t=1&ccb=2-4"
    a_addr = "https://scontent-itm1-1.cdninstagram.com/hvideo-frc-nha/_nc_cat-110/v/rASeBiSs9uMh-8k9MX2ywfcv2eDUjqTkWu88O8_87OYVbgQ/_nc_ohc-uyCGuC59WTEQ7kNvwFrSaj3/live-dash/dash-lp-hd-a/17876184243488447_0-#{n}.m4a?ms=m_C&sc_t=1&ccb=2-4"
    
    
    v_curl_result = `curl -s -o /dev/null -I -w "%{http_code}" #{v_addr}`.strip
    a_curl_result = `curl -s -o /dev/null -I -w "%{http_code}" #{a_addr}`.strip

    `curl -o ts/video/video_written_#{n}.mp4 #{v_addr}` if v_curl_result.include? '200'
    `curl -o ts/audio/audio_written_#{n}.mp4 #{a_addr}` if a_curl_result.include? '200'

    n = n - 1966 if v_curl_result.include? '200'
    n = n - 1 unless v_curl_result.include? '200'
    # n = n - 1
end

Dir.glob('ts/video/*').reverse.each do | v_filepath |
    puts "appending video #{v_filepath} to init"

    File.write('ts/video_init.m4v', File.open(v_filepath).read, mode: 'a')
end

Dir.glob('ts/audio/*').reverse.each do | a_filepath |
    puts "appending audio #{a_filepath} to init"

    File.write('ts/audio_init.mp4', File.open(a_filepath).read, mode: 'a')
end

# arr.reverse!.each do |time|
#     puts "downloading timing: #{time}"

#     v_addr = "https://scontent-itm1-1.cdninstagram.com/hvideo-ncg-vll/_nc_cat-100/v/rASev_R7oyBo4ARTG_X2xSm1pJnN5zOXKde8W3xw1oTHH9g/_nc_ohc-qN1x9SwQsFoQ7kNvwF17fmf/live-dash/dash-lp-hd-a/18065938747890199_0-#{n}.m4a?ms=m_C&sc_t=1&ccb=2-4"

#     File.write("ts/video_written_#{time}.mp4", `curl #{v_addr}`, mode: 'w')

#     a_addr="https://scontent-itm1-1.cdninstagram.com/hvideo-ncg-vll/_nc_cat-100/v/rASev_R7oyBo4ARTG_X2xSm1pJnN5zOXKde8W3xw1oTHH9g/_nc_ohc-qN1x9SwQsFoQ7kNvwF17fmf/live-dash/dash-lp-hd-a/18065938747890199_0-48203.m4a?ms=m_C&sc_t=1&ccb=2-4"

#     File.write("ts/audio_written_#{time}.mp4", `curl #{a_addr}`, mode: 'w')

#     sleep 0.1
# end

# 250612
# 액자, 이끼 추천, 타임오버 -매니저-, 분위기 읽어 
# 250806
# 소면 살찐다, 매니저가 왔냐, 개인이벤트 열어라
# 260204
# 시체 찾기가 됐어