# Plugin to export rasca alarms data
#

provides "rasca_status"

# Data directory for Rasca
DATADIR="/var/lib/modularit/data"

rasca_status Mash.new

Dir.glob("#{DATADIR}/*").each do |dir|
  alert=File.basename(dir)
  rasca_status[alert]=Mash.new
  Dir.glob("#{dir}/*.json").each do |file|
    str=File.read(file)
    entry=File.basename(file).gsub(/\.json$/,"")
    unless str.empty?
      rasca_status[alert][entry]=JSON.parse(str,:symbolize_names => true)
      rasca_status[alert][entry][:ctime]=File.stat(file).ctime
    end
  end
end

