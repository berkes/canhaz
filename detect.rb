require "rubygems"
require "mechanize"
require "hpricot"
require "progressbar"
require "./style"

base_url = "http://dic.audrey"
amount   = 50
# @TODO: should detect styles by itself; by crawling over the site.
styles = [:medium, :thumbnail, :large]

a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari' #@TODO prolly want to make it appear less like a bot.
  # TODO: Faux referrer and session here to circument "security" such as disallowing hotlinking.
}

page = a.get(base_url)
@response = page.content
doc = Hpricot(@response)

image_url = doc.search(".field-type-image img").first.attributes["src"]
style = Style.new(image_url)

method = ""
total = (amount * styles.count)
pbar = ProgressBar.new("fetching imgs", total)
(1..amount).each do |i|
  styles.each do |style_name|
    style.name = style_name.to_s
    # puts style.url
    # POC show that with apache fetching HEAD is enough to create the imagecached file. Makes it easier to DDOS.
    a.head(style.url)
    pbar.inc
  end
  style = style.nested
end
puts "calls: #{total}"
puts "example #{style.url}"
pbar.finish
