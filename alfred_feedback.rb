require "amatch"
require "nokogiri"

include Amatch

class Feedback

  attr_accessor :items

  def initialize(threshold = 0.45)
    @items = []
    @threshold = threshold
  end

  def add_item(opts = {})
    opts[:subtitle] ||= ""
    opts[:icon] ||= "icon.png"
    opts[:uid] ||= opts[:title]
    opts[:arg] ||= opts[:title]
    opts[:valid] ||= "yes"
    opts[:autocomplete] ||= opts[:title]

    @items << opts unless opts[:title].nil?
  end

  def items_with_score(query = "")
    @items.map do |item|
      item[:score] = query.jaro_similar(item[:title])
      item
    end
  end

  def filtered_items(query)
    return @items if query.strip.empty?

    items_with_score(query).select do |item|
      item[:score] > @threshold
    end.sort{ |a,b| b[:score] <=> a[:score] }
  end

  def filter(query)
    to_xml(filtered_items(query))
  end

  def to_xml(items = @items)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.items do
        items.each do |item|
          xml.item({:uid => item[:uid], :arg => item[:arg], :valid => item[:valid], :autocomplete => item[:autocomplete]}) do
            xml.title item[:title]
            xml.subtitle item[:subtitle]
            xml.icon item[:icon]
          end
        end
      end
    end

    builder.to_xml
  end

end
