require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "Publisher", "publish" do
  
  it "should send data to the dashboard server" do
    Dboard::Api::Client.should_receive(:post).with("/sources/new_relic", :body => { :data => { :db => "80%" }.to_json })
    Dboard::Publisher.publish(:new_relic, { :db => "80%" })
  end

  it "should handle and log socket errors" do
    Dboard::Api::Client.should_receive(:post).and_raise(SocketError.new("failed to connect"))
    Dboard::Publisher.should_receive(:puts).with("SocketError: failed to connect")
    Dboard::Publisher.publish(:new_relic, {})
  end

end
