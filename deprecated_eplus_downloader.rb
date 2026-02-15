require 'net/http'

# 2305 ~ 2660 356
# 2661 ~ 3020 359
# 2064 ~ 3380 359
# 60분마다 쿠키가 갱신되므로 360개 언저리에서 교체(ts 당 6~7초)

File.write('downlist_eplus.txt', '# File list of aac') unless File.exist? 'downlist_eplus.txt'

356.times do |idx|
  curl_down_path = "ts/index_5_#{(2305 + idx)}.ts"
  curl_cmd = "curl -o #{curl_down_path}"
  curl_cmd << " -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36'"
  curl_cmd << " -H 'Cookie: CloudFront-Key-Pair-Id=APKAIGT7LTF4AOTKRGEQ; CloudFront-Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiKlwvb3V0XC92MVwvNmIxMWExZmU4ZGEzNDljMzkwNmQwYjFmMTgzYjNjMmIqIiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNzcwNTQyMTU5fX19XX0_; CloudFront-Signature=VpxV25iAW-W15H6amqZsJDQTXPQH%7Eu%7EWH3GjaT12BhUl7HgVAD9Y6k-tvnSKXGTAJcnP29fWV4aroXS6OIOy1AWufVzVWKfvmCJ06BjHhDKCS%7E2O2OORFh5lMhYW4lh5QXu-6uPZOb7iWO6HNWCOBOLGaCh5qyMDn8JvaaVwQ9lHSsaB5MEJ4AcEjCUYrLbVR7Bi9je0fEzcojk4Ls3urjP0clQd0VQ8F7eUn2o4y2jhak4uPrz9icyYGoHfY47GtAfL2tLNcNdTskACNcrT%7EC7DoJXZ-uOMLFDNm4gfvau9UqfCklNdGQ1NrABqomCrgXV7eU7Sh7TeIHjbu1LrIg__; KOJIN_SHIKIBETSU=260207111012S14220; __lt__cid=a9f70fbf-18b5-425d-b38f-f6e9b0b84b4c; _yjsu_yjad=1770430213.00c36208-103e-4ed1-ac9c-dd9a897075cb; _fbp=fb.1.1770430213046.444085481819581218; usertrack_asp3=1739115402501.5679096797; _tt_enable_cookie=1; _ttp=01KGTXTB36Z9J621VWHG2KC633_.tt.1; sess_88469577=member.eplus.jp_20260207111344919sDZjv; MEMBER_ID=6cba81f6de3034553d7676c93e616831; TODOFUKEN_CODE=13; __lt__sid=88d91b23-681e856f; _ga=GA1.1.223284366.1770430213; ak_bmsc=DD672FFB5E2A681E5A28BE2D849435C1~000000000000000000000000000000~YAAQUlLNF75sty6cAQAAUBBSPB4FeuvCXAN5iP7e19xkudQgj/HCYYo40nuX8uqRU2MDnGCvCk4JGAA3P1hwPw1tt5sjIXz0OzeoFxl8MfSOl9FKvn6pEh6RI+IKHgwmYzswn0PEW2qAamGo2LrMNoY0XNT+zdgB7IDVtDFejLbfjh0cO1AUCKtLMcO67H7An9+4O+FbO348MFVhvaCdNcJtuUIpLx2a4+Bbn4ckDIU8jrfqSm3NsQTWgMPgLWfyE2KRzhMvANhO1PCcV5m1NS/vYysOziRcQjzBkGkL0xFGx+sC4PdKjXQjCJ6b8S/f4ysG86OxeAbZsAA7RCHHnaCVB/MqBATL6eK46+8U//67QAxBF6cufvLX0fwv8BBTsbFNb5LAQD8jAXxguXt39O0vZXze7C3szXBbFWge//MDSt1w7R6EupPXSX5/nX3R; _gcl_au=1.1.1158943843.1770430213.1076607093.1770538538.1770538537; _abck=733DE3F30852B825565F4A9AE47989B1~0~YAAQUlLNF2pvty6cAQAAABRSPA+9XqfrrexY+YGeQhm6doIrjM7pPgqnXuOxeQr5ceUfx7sjCFl5fyOOlE6pDmcqJ5HPjL1zgH2OPFY+VNNcfcPozFkWk/BigYs9CE23bS4u69mqqh8jBs90DobHPSWSsTkeUwLWzEHycxlqofakXB4v88+8qiZFDGvd2JL3+ijm9w09ncbpphPsqAEGn4nUn5n+/1myg1+Azc8QvFe7tOnKFbKIIYIgZkDErfiXkiY6iZwRz7XEcrIVR8Eb53rG3s71gBQiwMaojqBuwprD0MGI8jT2kED3kmU7/bow5d6wmweQnZkaaLO5AhO1o4Qw06hpvSHnGA91SGNVp2D6BICs3KEvQO5PztuZavxbh+8/w7tKD8Ki8ZcJpkpsqNePPjRq1MzzeQDsHQ55WS0nNxRA+di9iVOi2Di7dctrEw2Jfq9hHJ3c8cBROjDx235T84o14W1XWklctWb7XM1Yi+yT0AxaMoT0ixRGIO2IWgPQK5TcCXhq/T5iZxcAolmcUSuqDmlDuBmqmD6GJwABEMJBYvzdhL4cldZOpdguJY3q2ZF/0igZwa84c6nQ1vpxKHkxpJa5+k5wmM+dO9vjsgBAjvEcQ1Oath5U7jTUT5Vp9lDHIWUp2oNXST7ll4+EPoVMDFjKcSOASX4kZ4y8xruR7P3vesGLkbZjOVsDr4Dd+vMw0N6bzNTRWUF4hbx5Xk6wYPDtYy5gQavkTGNlBaYF80WdG4/vY9vf3bSW8oRkjTN1aTDwgUwkryLksnsuD9EsvA==~-1~-1~-1~AAQAAAAF%2f%2f%2f%2f%2f+H1IuIyp0vzCe3GLCHE%2figY4n6OsTHgzz%2f9uP6ta3dfnISDYABLKoyYyl8S4+0kx3YrrQdQl1ZGUEJGSrv9fwfxDvFlWR21A0fJ~-1; EPLUS_CLOUD_ACCESS_TOKEN=868ffdc7bcd954b54bd076308b8e0aec11a0bdd2e4b43c8e4a39899ebcdf709540e096195be4a1106977f35f138b8640; bm_sz=51710CD0077803ECC9C2BC192B979641~YAAQUlLNF3xxty6cAQAAshZSPB4jkFpmSELHFqEThZjT3/lZXrQxvvSvwEewjH+3znXgBLFCZQwJpZennVopJ4aJHfP2Ng6m0CarwG2X/TMsiRNXLV+8biIMlvLBPVdZ/105dKZWPyIPSQ2CO06AKf5zoqz7Pg/mjoUHqi9oVtcwhF7osChd1q7bibo4Ze+UWQg3CD+yrmm6vRR9g2+sFm/MlgI1g+EqQ6oGiy15G7o78sihq1GQfn1TJTbAzr8hX3AwpwcSkcqf+t7RVtamF4pFOTcAB5Kaov8/eVbPPAW+0HIl6J43xA/vey4UiKVaLDRpGmTB1wHImlEEV5AH8PC3I1Rw6GolMwesiesRGwbwwSiNzgIwmwG6NwtZIHdC/x2y8/bjTsNJsHt/e+eKv8EjslwbBf/vR355KfcoWcQ1QQaU+hGiU8IwabewBr1zT21D5g==~3158833~3556921; bm_sv=AC93A81EC0B6967D918EFA15E3CAD256~YAAQUlLNF7l6ty6cAQAAxCJSPB4xxBiqlOdqM0WchjGn0IFdnx6Dz8T+rgNJkSa4OQQjDSYjUD2jPIuckXqy3rte/J31h24EaOhBEgzw7cFUrFrEIEliX1xrt5iMF6/NXuTIYZ26hzZZk3NQtYbW5i+z4M9JmUlGgGSHu1wsZU/X0kwcu+BtiauLbz0dwXepF5YkofAp6ijo4/C+bBtgFKvH0w1aVWap7lnqqCLrY0VnDFFHk8sUEYKeUR+JgA==~1; ttcsid=1770538531659::BkTr53zUELIFr227TJqH.3.1770538550305.0; ttcsid_BUH54E9LQKRCN7NEEM20=1770538531659::Bew7kWBvH4V8HT2ts9PT.3.1770538550306.1; _ga_SQ2W44L884=GS2.1.s1770538531$o3$g1$t1770538550$j41$l0$h0; _ga_N0WZ46MWGY=GS2.1.s1770538551$o4$g1$t1770538559$j52$l0$h0'"
  curl_cmd << " -H 'Sec-Ch-Ua-Platform: macOS'"
  curl_cmd << " -H 'Pragma: no-cache'"
  curl_cmd << " -H 'Sec-Ch-Ua: \"Google Chrome\";v=\"119\", \"Chromium\";v=\"119\", \"Not?A_Brand\";v=\"24\"'"
  curl_cmd << " -H 'Origin: https://live.eplus.jp'"
  curl_cmd << " -H 'Referer: https://live.eplus.jp/'"
  curl_cmd << " https://vod.live.eplus.jp/out/v1/6b11a1fe8da349c3906d0b1f183b3c2b/1217ea8208d896cce97713792fe3b8dd/index_5_#{(2859 + idx)}.ts"
  system(curl_cmd)
  next if File.size("ts/index_5_#{(2305+idx)}.ts") < 500
  File.write('downlist_eplus.txt', "\nfile #{curl_down_path}", mode: 'a')
end

system('ffmpeg -f concat -safe 0 -i downlist_eplus.txt -c copy eplus_output.ts')
# system('ffmpeg -i eplus_output.ts -c:v libx264 -c:a copy eplus_output_2.mp4')
# system('rm -rf downlist_eplus.txt ts/* eplus_output.ts')
system('rm -rf downlist_eplus.txt ts/*')

# for idx in {1633..2711}; do curl -o ffmpeg/ts/index_5_${idx}.ts "${idx}.ts"; done
