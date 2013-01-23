require 'time'
load "alfred_feedback.rb"

Data_File = File.expand_path("recent_downloads.txt",
                             "~/Library/Application Support/Alfred 2/Workflow Data")
DIR = File.expand_path "~/Downloads"

Dir.chdir DIR
def time_added(entry)
  time = `mdls -name kMDItemDateAdded -raw "#{entry}"`
  Time.parse time
end

results = []
File.open(Data_File, "r") do |file|
  content = file.gets(nil)
  results += content.split "\n" if content
end if File.exist? Data_File

entries = Dir.entries(".").delete_if {|x| x.start_with? "."}
results = results & entries # remove entries that are no longer in the Downloads folder
entries = entries - results # process only newer ones

entries.collect! {|x| {:name => x, :time_added => time_added(x)}}
entries.sort! {|x, y| y[:time_added] <=> x[:time_added]}
results = entries.collect! {|x| x[:name]} + results
File.open(Data_File, "w") do |file|
  results.each {|x| file.puts x}
end

pattern = Regexp.compile("#{[*ARGV[0].chars] * ".*"}", true)
results.delete_if {|x| (x =~ pattern) == nil}

# construct feedback
feedback = Feedback.new
if results.length > 0
  results.each do |path|
    fullpath = File.expand_path path
    feedback.add_item({:title => path, :subtitle => "Open File", :arg => fullpath,
                        :icon => {:type => "fileicon", :name => fullpath}})
  end
else
  feedback.add_item({:title => "No Match", :valid => "no"})
end

puts feedback.to_xml
