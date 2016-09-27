require 'rubygems'
require 'bundler/setup'

# require your gems as usual
require 'mechanize'
require 'nokogiri'
require 'awesome_print'

id = 'REPLACE_YOUR_ID'
password = 'REPLACE_YOUR_PASSWORD'
shop_id = 'REPLACE_YOUR_SHOPID'

agent = Mechanize.new
agent.get('https://nettomotto.jp/') do |page|
  mypage = page.form_with(name: 'form1') do |form|
    form.id = id
    form.password = password
  end.submit

  page = page.link_with(:href => '/r/top').click

  form =  page.form('form5')
  page = agent.submit(form)

  form =  page.form("formo#{shop_id}")
  page = agent.submit(form)

  page.links.each do |link|
    next if link.href !~ /\/r\/item\/detail\/.*/
    subpage = link.click
    doc = Nokogiri::HTML(subpage.content.toutf8)
    kcal = doc.xpath('//*[@id="rice_m1"]/table/tr[3]/td[1]').text
    item_name =  link.text.gsub(" ", "").strip!
    ap "%s %s"%[kcal,item_name]
  end
end
