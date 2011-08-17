require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

# Test app
require 'sinatra'

get "/sources" do
  Dboard::Api.get(params)
end

post "/sources/:type" do
  Dboard::Api.update(params)
end

describe "Dashboard" do

  def app
    Sinatra::Application
  end  

  def start_app
    app.port = 20843
    app.environment = 'test'
    @app_thread = Thread.new { app.run! }
    sleep 1
  end

  def stop_app
    @app_thread && @app_thread.kill
  end

  before do
    ENV['API_URL'] = "http://localhost:20843"
    ENV['API_USER'] = 'test'
    ENV['API_PASSWORD'] = 'test'
    @new_relic = mock
    @new_relic.stub!(:fetch).and_return({ :db => "33.3%", :memory => "33333 MB" })
    Dboard::CACHE.delete "dashboard::source::new_relic"
  end
  
  it "should collect stats and post them to the server" do
    start_app
    body = Dboard::Api::Client.get("/sources?types=new_relic")
    JSON.parse(body)["sources"]["new_relic"]["data"].should == {}
    Dboard::Collector.instance.update_source(:new_relic, @new_relic)
    body = Dboard::Api::Client.get("/sources?types=new_relic")
    JSON.parse(body)["sources"]["new_relic"]["data"].should == { "db" => "33.3%", "memory" => "33333 MB" }
  end

  after do
    stop_app
  end

end

