require 'key_binding'

describe KeyBinding do
  describe "#new" do
    context "when passed a string" do
      it "creates a KeyBinding" do
        expect(KeyBinding.new("a,b,c,d")).to be_a(KeyBinding)
      end
    end
    context "when passed nil" do
      it "creates a KeyBinding" do
        expect(KeyBinding.new(nil)).to be_a(KeyBinding)
      end
    end
  end
  describe "#all" do
    context "when no bindings" do
      it "returns an empty array" do
        a = KeyBinding.new(nil).all
        expect(a).to be_a(Array)
        expect(a.empty?).to be true
      end
    end
    context "with bindings" do
      it "returns array of each binding" do
        a = KeyBinding.new("a,b,c,d").all
        expect(a).to be_a(Array)
        expect(a).to eq([ "a", "b", "c", "d" ])
      end
    end
  end
  describe "#pri" do
    context "when no bindings" do
      it "returns nil" do
        expect(KeyBinding.new.pri).to be_nil
      end
    end
    context "with bindings" do
      it "returns first binding" do
        expect(KeyBinding.new("a,b,c,d").pri).to eq("a")
      end
    end
  end
  describe "#alt" do
    context "when no bindings" do
      it "returns empty array" do
        a = KeyBinding.new.alt
        expect(a).to be_an(Array)
        expect(a.empty?).to be true
      end
    end
    context "with bindings" do
      it "returns array of alternative bindings" do
        expect(KeyBinding.new("a,b,c,d").alt).to eq([ "b", "c", "d" ])
      end
    end
  end
end
