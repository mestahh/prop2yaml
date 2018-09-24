require 'spec_helper'
require 'prop2yaml'

RSpec.describe 'Prop2Yaml' do
	
	it 'resolves a single key' do 
		expected_hash = {"title" => "TV GO"}
		expect(Prop2Yaml.new.convert("title", "TV GO").to_hash).to eq(expected_hash)
	end

	it 'resolves double keys key' do 
		expected_hash = {"html" => [{"title" => "TV GO"}]}
		expect(Prop2Yaml.new.convert("html.title", "TV GO").to_hash).to eq(expected_hash)
	end

	it 'resolves triple keys key' do 
		expected_hash = {"html" => [{"head" => [{"title" => "TV GO"}]}]}
		expect(Prop2Yaml.new.convert("html.head.title", "TV GO").to_hash).to eq(expected_hash)
	end

	it "merges the result together" do
		expected_hash = {"html" => [{"head" => [{"title" => "TV GO"}, "index" => "index.html"]}]}
		
		tree1 = Prop2Yaml.new.convert("html.head.title", "TV GO")
		tree2 = Prop2Yaml.new.convert("html.head.index", "index.html")

		expect(Prop2Yaml.new.merge(tree1, tree2).to_hash).to eq(expected_hash)
	end

	it "merges the result together" do
		expected_hash = {"ROOT" => [{"html" => [{"head" => [{"title" => "TV GO"}, "index" => "index.html"]}]}, {"title" => "other"}]}
		
		tree1 = Prop2Yaml.new.convert("html.head.title", "TV GO")
		tree2 = Prop2Yaml.new.convert("html.head.index", "index.html")
		tree3 = Prop2Yaml.new.convert("title", "other")

		expect(Prop2Yaml.new.merge_trees([tree1, tree2, tree3]).to_hash).to eq(expected_hash)
		puts Prop2Yaml.new.merge_trees([tree1, tree2, tree3]).to_s(0)
	end

end