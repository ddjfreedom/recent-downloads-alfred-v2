require "nokogiri"

class Feedback

  attr_accessor :items

  def initialize
    @items = []
  end

  def add_item(opts = {})
    opts[:subtitle] ||= ""
    opts[:icon] ||= {:type => "default", :name => "icon.png"}
    opts[:uid] ||= opts[:title]
    opts[:arg] ||= opts[:title]
    opts[:valid] ||= "yes"
    opts[:autocomplete] ||= opts[:title]

    @items << opts unless opts[:title].nil?
  end

  def to_xml(items = @items)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.items do
        items.each do |item|
          xml.item({:uid => item[:uid], :arg => item[:arg], :valid => item[:valid], :autocomplete => item[:autocomplete]}) do
            xml.title item[:title]
            xml.subtitle item[:subtitle]
            case item[:icon][:type]
            when "default"
              xml.icon item[:icon][:name]
            when "fileicon"
              xml.icon({:type => "fileicon"}, item[:icon][:name])
            end
          end
        end
      end
    end

    builder.to_xml
  end

end
