require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe Dboard::Collector, "register_source" do
  before do
    Dboard::Collector.instance.sources.clear
  end

  it "can register a source" do
    new_relic = mock
    new_relic.stub!(:update_interval).and_return(5)
    Dboard::Collector.register_source :new_relic, new_relic
    Dboard::Collector.instance.sources.should == { :new_relic => new_relic }
  end

  it "can register an after update callback" do
    new_relic = mock
    new_relic.stub!(:fetch).and_return({ :db => "100%" })
    callback = mock
    Dboard::Collector.register_after_update_callback callback

    callback.should_receive(:call)
    Dboard::Publisher.stub!(:publish)
    Dboard::Collector.instance.update_source(:new_relic, new_relic)

    # since it is a singleton, and this callbacks leaks into the other tests
    Dboard::Collector.register_after_update_callback(lambda {})
  end

  it "can register an error callback" do
    new_relic = mock
    error = RuntimeError.new("error")
    new_relic.stub!(:fetch).and_raise(error)
    callback = mock
    Dboard::Collector.register_error_callback callback

    callback.should_receive(:call).with(error)
    Dboard::Publisher.stub!(:publish)
    Dboard::Collector.instance.update_source(:new_relic, new_relic)

    # since it is a singleton, and this callbacks leaks into the other tests
    Dboard::Collector.register_error_callback(lambda { |_| })
  end
end

describe Dboard::Collector, "update_source" do
  before do
    Dboard::Collector.instance.sources.clear
  end

  it "should collect and publish data from sources" do
    new_relic = mock
    new_relic.stub!(:fetch).and_return({ :db => "100%" })
    Dboard::Publisher.should_receive(:publish).with(:new_relic, { :db => "100%" })
    Dboard::Collector.instance.update_source(:new_relic, new_relic)
  end

  it "should print out debugging info" do
    new_relic = mock
    new_relic.stub!(:fetch).and_raise(Exception.new("some error"))
    Dboard::Collector.instance.should_receive(:puts).twice
    Dboard::Collector.instance.update_source(:new_relic, new_relic)
  end
end
