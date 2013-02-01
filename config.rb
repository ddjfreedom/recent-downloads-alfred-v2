require 'yaml'

class Config
  BUNDLE_ID       = "recentdownloads.ddjfreedom"
  VOLATILE_DIR    = File.expand_path BUNDLE_ID, "~/Library/Caches/com.runningwithcrayons.Alfred-2/Workflow Data/"
  NONVOLATILE_DIR = File.expand_path BUNDLE_ID, "~/Library/Application Support/Alfred 2/Workflow Data/"
  Dir.mkdir VOLATILE_DIR unless File.exist? VOLATILE_DIR
  Dir.mkdir NONVOLATILE_DIR unless File.exist? NONVOLATILE_DIR
  
  def initialize
    config_file_path = File.expand_path "config.yaml", NONVOLATILE_DIR
    if File.exist? config_file_path
      @config = File.open(config_file_path, "r") {|f| YAML.load f}
    else
      @config = {"install_action" => "ask",
                 "auto_start"     => "ask"}
      File.open(config_file_path, "w") {|f| YAML.dump @config, f}
    end
  end

  def [](key)
    @config[key]
  end
  
  def method_missing(sym, *arg)
    @config[sym.to_s]
  end
end
