require 'eventmachine'
require 'sinatra/base'
require 'sinatra/async'
require 'thin'

class App < Sinatra::Base
  register Sinatra::Async

  set :public_folder, File.expand_path("../../../../" ,__FILE__)
  set(:resource_locations, {
    "index" => File.expand_path("../../templates/report/illustrate-live.html", __FILE__),
    "illustrate_template" => File.expand_path("../../templates/report/illustrate-report.html", __FILE__),
    "illustrate_css" => File.expand_path("../../../../css/illustrate.css", __FILE__),
    "jquery" => File.expand_path("../../../../js/jquery-1.7.1.min.js", __FILE__),
    "jquery_transit" => File.expand_path("../../../../js/jquery.transit.js", __FILE__),
    "jquery_stylestack" => File.expand_path("../../../../js/jquery.stylestack.js", __FILE__),
    "mortar_table" => File.expand_path("../../../../js/mortar-table.js", __FILE__),
    "zeroclipboard" => File.expand_path("../../../../js/zero_clipboard.js", __FILE__),
    "zeroclipboard_swf" => File.expand_path("../../../../flash/zeroclipboard.swf", __FILE__)
  })

  set :connections, []
  # Sinatra code here
  get '/' do
    body File.read(settings.resource_locations["index"]).to_s
  end

  aget '/illustrate-results.json' do
    settings.connections << lambda { |data|
      EM.next_tick do
        body { data }
      end
    }
  end

end

