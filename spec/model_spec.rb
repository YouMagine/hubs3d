require "spec_helper"
require "hubs3d/model"

describe Hubs3D::Model do
  let(:model) do
    described_class.new(name: "foo.stl",
                        path: "spec/fixtures/example.stl",
                        attachments: ["foobar"])
  end

  describe "#name" do
    it "returns the name" do
      expect(model.name).to eq "foo.stl"
    end
  end

  describe "#path" do
    it "returns the path" do
      expect(model.path).to eq "spec/fixtures/example.stl"
    end
  end

  describe "#id" do
    it "triggers #post if @id is not set" do
      stub_request(:post, "https://www.3dhubs.com/api/v1/model")
        .with(body: {"attachments"=>"foobar", "file"=>"Rk9vTwo=\n", "fileName"=>"foo.stl"},
              headers: {"Accept" => "application/json"})
        .to_return(status: 200, body: "{\"modelId\":\"42\"}")

      expect(model.id).to eq(42)
    end

    it "only returns @id if it is already set" do
      model.instance_variable_set(:@id, 3)
      expect(model).to_not receive(:post)
      model.id
    end
  end

  describe "#attachments" do
    it "returns the attachments" do
      expect(model.attachments).to match_array ["foobar"]
    end
  end

  describe "#base_64_file" do
    it "reads the file contents and returns the base64 representation" do
      expect(model.send(:base_64_file)).to eq "Rk9vTwo=\n"
    end
  end

  describe "#post" do
    it "fires a POST request with the right parameters" do
      allow(model).to receive(:base_64).and_return("foobar")

      expect(Hubs3D::API).to receive(:post).with("/model",
                                         file: "Rk9vTwo=\n",
                                         fileName: "foo.stl",
                                         attachments: ["foobar"])

      model.send(:post)
    end
  end
end
