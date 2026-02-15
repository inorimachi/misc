require 'net/http'

n = 389
arr = []
limit = 0

while n > limit do
    puts "pushed timing: #{n.to_s}"    
    
    v_addr = "https://vod-abematv.akamaized.net/mp4pg/DZS1trpwKWhtxF/Gg2NZvxXTys6dfN3xyJKXT/1080p.1/#{n}.m4s?v=3&aver=9EPERR9PNESuLB"
    a_addr = "https://vod-abematv.akamaized.net/mp4pg/DZS1trpwKWhtxF/Gg2NZvxXTys6dfN3xyJKXT/1080p.2/#{n}.m4s?v=3&aver=9EPERR9PNESuLB"
    
    
    v_curl_result = `curl -s -o /dev/null -I -w "%{http_code}" #{v_addr}`.strip
    a_curl_result = `curl -s -o /dev/null -I -w "%{http_code}" #{a_addr}`.strip

    `curl -s -H 'Referer: https://abema.tv/' -o ts/video/video_written_#{n}.mp4 #{v_addr}` if v_curl_result.include? '200'
    `curl -s -H 'Referer: https://abema.tv/' -o ts/audio/audio_written_#{n}.mp4 #{a_addr}` if a_curl_result.include? '200'

    # n = n - 1966 if v_curl_result.include? '200'
    # n = n - 1 unless v_curl_result.include? '200'
    n = n - 1
end

# arr.reverse!.each do |time|
#     puts "downloading timing: #{time}"

#     v_addr = "https://scontent-nrt1-1.cdninstagram.com/hvideo-pnb-frc/_nc_cat-109/v/rASfqPWcL5Man9PvfOvnFSGvtgBml-orCainwZbDKoG7rEw/_nc_ohc-NHDFkw910ugQ7kNvgFIpU2b/live-dash/dash-lp-pst-v/18012006824312080_0-#{time}.m4v?ms=m_C&amp;sc_t=1&amp;ccb=2-4"

#     File.write("ts/video_written_#{time}.mp4", `curl #{v_addr}`, mode: 'w')

#     a_addr="https://scontent-nrt1-1.cdninstagram.com/hvideo-pnb-frc/_nc_cat-109/v/rASfqPWcL5Man9PvfOvnFSGvtgBml-orCainwZbDKoG7rEw/_nc_ohc-NHDFkw910ugQ7kNvgFIpU2b/live-dash/dash-lp-hd-a/18012006824312080_0-#{time}.m4a?ms=m_C&amp;sc_t=1&amp;ccb=2-4"

#     File.write("ts/audio_written_#{time}.mp4", `curl #{a_addr}`, mode: 'w')

#     sleep 0.1
# end