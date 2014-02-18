require 'time'
require 'find'
require 'shellwords'
load "alfred_feedback.rb"
load "config.rb"
load "download_progress.rb"

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

$config = RDW::Config.new

Data_File = File.expand_path "recent_downloads.txt", RDW::Config::VOLATILE_DIR

DIR = File.expand_path "~/Downloads"

Dir.chdir DIR

def get_entries(dir, max_depth)
  xs = []
  dir = File.expand_path dir
  max_depth += dir.split(File::SEPARATOR).count
  Find.find(dir) do |path|
    if RDW.directory? path
      if path.split(File::SEPARATOR).count < max_depth
        xs <<= path
        next
      elsif path.split(File::SEPARATOR).count == max_depth
        xs <<= path
      end
    elsif !RDW.hidden? path
      xs <<= path
    end
    Find.prune
  end
  xs
end

results = []
File.open(Data_File, "r") do |file|
  content = file.gets(nil)
  results += content.split "\n" if content
end if File.exist?(Data_File) && File.mtime($config.config_file_path) < File.mtime(Data_File)

entries = get_entries ".", 1
excludes = [File.expand_path(".")]
$config.subfolders.each do |x|
  next if !File.exist? x["folder"]
  excludes <<= File.expand_path(x["folder"]) if x["exclude"]
  entries += get_entries x["folder"], x["depth"]
end
entries -= excludes
entries.uniq!
results = results & entries # remove entries that are no longer in the Downloads folder
entries = entries - results # process only newer ones

if entries.length > 0
  escaped_entries = entries.map do |entry|
    Shellwords.escape(entry)
  end

  time_values = `mdls -name kMDItemDateAdded -raw #{escaped_entries.join(' ')}`.split("\0")

  entries = entries.each_with_index.map do |entry, i|
    if time_values[i] == "(null)"
      time = File.mtime entry
    else
      time = Time.parse time_values[i]
    end
    {:name => entry, :time_added => time}
  end

  entries.sort! {|x, y| y[:time_added] <=> x[:time_added]}
end

results = entries.collect! {|x| x[:name]} + results
File.open(Data_File, "w") do |file|
  results.each {|x| file.puts x}
end

query = ARGV[0].gsub(/\s+/, "")
pattern = Regexp.compile("#{[*query.chars.to_a.map! {|c| Regexp.escape c}] * ".*"}", true)
results.delete_if {|x| (File.basename(x) =~ pattern) == nil}

# construct feedback
feedback = Feedback.new
if results.length > 0
  results = results.first($config['max-entries']) if $config['max-entries'] != :all
  results.each do |path|
    fullpath = File.expand_path path
    if path[path.length - 9, 9] == '.download'
      feedback.add_item(download_item(fullpath))
    else
      feedback.add_item({:title => File.basename(path), :subtitle => path, :arg => fullpath,
                          :icon => {:type => "fileicon", :name => fullpath}})
    end
  end
else
  feedback.add_item({:title => "No Match", :valid => "no"})
end

puts feedback.to_xml
