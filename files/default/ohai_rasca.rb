# Plugin to export rasca alarms data

require 'ffi_yajl'

Ohai.plugin(:Rasca) do
  provides "rasca_status"

  collect_data do
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
          begin
            json_parser = FFI_Yajl::Parser.new
            hash = json_parser.parse(str)
            rasca_status[alert][entry] = hash || Mash.new
            # should exist because the file did, even if it didn't
            # contain anything
            rasca_status[alert][entry][:ctime]=File.stat(file).ctime
          rescue FFI_Yajl::ParseError => e
            Ohai::Log.error("Could not parse hint file at #{filename}: #{e.message}")
          end
        end
      end
    end
  end
end

