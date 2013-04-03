# encoding: UTF-8

# Helper functions for formatting bytes to how Finder displays them.
module OSXBytes
  # Turns a float into an integer if it doesn't have a value after the demical
  # place (ex: 13.0 converts to 13 (an int), 13.5 doesn't change)
  # Yeah, I'm bad at naming things.
  def self.remove_trailing_zero(float)
    if float - float.to_i == 0
      float.to_i
    else
      float
    end
  end

  # Round number to a specified number of decimal places.
  def self.round_number(number, digits)
    (number * 10 ** digits).round.to_f / 10 ** digits
  end

  # Get floor of a number to a specified number of decimal places.
  def self.floor_number(number, digits)
    (number * 10 ** digits).floor.to_f / 10 ** digits
  end

  # Displays a readable representation of a file size, mimicking Finder's
  # representation.
  # 
  # 1 KB = 1000 bytes, as in OS X 10.6 and up
  def self.format(bytes)
    units = %w[B KB MB GB TB]
    
    max_exp = units.size - 1
    exp = (Math.log(bytes) / Math.log(1000)).to_i
    exp = max_exp if exp > max_exp

    number = (bytes / 1000.0 ** exp)
    
    # Display up to 2 decimal points for GBs and TBs, 1 for MBs, and round to
    # the nearest integer for B and KB.
    number = if exp > 2
      self.round_number(number, 2)
    else
      self.round_number(number, (exp == 0) ? exp : exp - 1)
    end
    
    number = self.remove_trailing_zero(number)
    
    "#{number} #{units[exp]}"
  end
end

def download_item(path)
  downloaded_file = "#{path}/#{path.split('/').last.chomp('.download')}"
  plist_file = "#{path}/Info.plist"
  total_size = `/usr/libexec/PlistBuddy -c Print:DownloadEntryProgressTotalToLoad "#{plist_file}"`.to_f
  current_size = File::stat(downloaded_file).size
  percent = (current_size / total_size) * 100
  icon = "/Applications/Safari.app/Contents/Resources/download#{(percent / 10).floor}.icns"
  
  {
    :title => File.basename(path).chomp('.download'),
    :subtitle => "Download is %0.1f%% complete — %s of %s" % [
      percent,
      OSXBytes::format(current_size),
      OSXBytes::format(total_size)
    ],
    :arg => path,
    :icon => {:name => icon}
  }
end