require 'rench'

describe Rench::CLI do
  let(:rench) { Rench::CLI.new "mrmicahcooper", "file.txt" }
  let(:highline) { rench.highline }

  describe "#crank" do
    it "asks for a username" do
      rench.should_receive(:ask_for_username)
      rench.crank
    end

    it "asks to choose a file" do
      rench.should_receive(:choose_file)
      rench.crank
    end

    it "downloads the tool"
  end

  describe "#ask_for_username" do
    context "when NOT initialized with a username" do
      let(:rench) { Rench::CLI.new }
      it "prompts for username" do
        highline.should_receive(:ask).with("Enter a Github username")
        rench.ask_for_username
      end
    end

    context "when initialized with a username" do
      it "doesn't prompt for username" do
        highline.should_not_receive(:ask)
        rench.ask_for_username
      end
    end
  end

  describe "#choose_file" do
    context "when NOT initialized with filename" do
      let(:rench) { Rench::CLI.new "mrmicahcooper" }
      it "asks to choose a file from the tool menu" do
        tools = []
        highline.should_receive(:choose).with(tools)
        rench.should_receive(:tool_menu).and_return(tools)
        rench.choose_file
      end
    end
    context "when initialized with filename" do
      it "does not ask to choose a file" do
        highline.should_not_receive(:choose)
        rench.choose_file
      end
    end
  end

  describe "#tool_menu" do
    context "when there are no tools" do
      before do
        response = double(status: 400, body: "")
        Faraday::Connection.any_instance.stub(get: response)
      end
      it "returns a 'no tools' message" do
        highline.should_receive(:say).with("No toolbox found for mrmicahcooper")
        begin
          rench.tool_menu
        rescue SystemExit
        end
      end
    end

    context "when there are tools" do
      before do
        response = double(status: 200, body: '[{"name":"tool.txt"}]')
        Faraday::Connection.any_instance.stub(get: response)
      end
      it "returns an array of tool names" do
        rench.tool_menu.should == ["tool.txt"]
      end
    end
  end
end
