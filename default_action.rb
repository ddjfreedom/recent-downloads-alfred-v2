require 'yaml'
Config_Dir = File.expand_path "recentdownloads.ddjfreedom", "~/Library/Application Support/Alfred 2/Workflow Data/"
Dir.mkdir Config_Dir unless File.exist? Config_Dir
Config_File = File.expand_path "config.yaml", Config_Dir

if File.exist? Config_File
  config = File.open(Config_File, "r") {|file| YAML.load file}
else
  config = {"install_action" => "ask", "auto_start" => "ask"}
  File.open(Config_File, "w") {|file| YAML.dump config, file}
end

unless ["ask", "install", "open", "cancel"].include?(config["install_action"]) &&
    ["ask", "always", "never"].include?(config["auto_start"])
  puts "Error: Invalid Configuration"
  exit 0
end

need_install = case File.extname ARGV[0]
               when ".app"
                 $QUESTION = "#{ARGV[0]} is an application.\n\nDo you want to open it at the downloaded location or install it?"
                 true
               when ".dmg"
                 $QUESTION = "#{ARGV[0]} is a disk image.\n\nDo you want to open it or install any applications it contains?"
                 true
               when ".zip"
                 $QUESTION = "#{File.basename ARGV[0]} contains one or more applications.\n\nWhat would you like to do?"
                 "0" != `zipinfo -1 "#{ARGV[0]}" | grep -e "\.app/$" -e "\.pkg$" -e "\.mpkg/$" -e "\.dmg$" -e "\.prefPane/$" | grep -v -e ".*\.mpkg/.*\.pkg$" -e ".*\.app/.*\.app/$" -e ".*\.prefPane/.*\.app/$" -e ".*\.prefPane/.*\.mpkg/$" -e ".*\.prefPane/.*\.pkg$" | grep -i -v "__MACOSX" | sed -e 's#/$##' | wc -l`.strip
               else
                 false
               end

if need_install
  action = config["install_action"].capitalize
  action = `osascript 2> /dev/null <<-EOF
                tell application "System Events"
                    try
                    set question to display dialog "#{$QUESTION}" buttons {"Install","Open","Cancel"} default button 1 with title "Alfred Recent Downloads" with icon caution
                    set answer to button returned of question
                    on error number -128
                    set answer to "Cancel"
                    end try
                    return answer
            end tell
            EOF`.strip if action == "Ask"
  case action
  when "Install"
    output = `/bin/bash installSoftware.sh -s #{config["auto_start"]} #{ARGV[0]}`
    puts output
  when "Open"
    `open #{ARGV[0]}`
  else
    # Do nothing
  end
else
  `open #{ARGV[0]}`
end
