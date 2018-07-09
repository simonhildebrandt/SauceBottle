require 'rubygems'
require 'nokogiri'
require 'irb'
require 'json'
require 'date'
#require 'byebug'


@page = Nokogiri::HTML(open('messages.htm'))

# Jacky = 501740704@facebook.com
# Simon = 731647233@facebook.com

@sections = @page.css('.contents').css('> div')

@section = @sections[0]

@threads = @section.css('.thread')

@messages = @threads.map{|thread| thread.css('.message, p')}.flatten

@current_message = {
  user: "[unkown user]",
  time: "[unknown time]"
}

$id = 0
def extract(node)
  if node.name == 'p'
    @current_message.dup.merge body: node.text
  else
    node.css('.meta').text =~ /(\d{1,} \w{3,} \d{4}) at (\d{2}:\d{2}) (UTC[\+\-]*\d{1,})/
    time = DateTime.parse("#{$1} #{$2} #{$3}").to_time

    @current_message = {
      id: $id+=1,
      timestamp: time.to_i,
      user: node.css('.user').text,
      time: time
    }
    nil
  end
end

@data = @messages.map(&method(:extract)).compact

#IRB.start

JSON.dump(@data, open('messages.json', 'w'))
