class YamlTree

	attr_accessor :name, :nodes, :leaf

	def initialize
		@nodes = []
	end

	def to_hash
		unless @nodes.empty?
			{name => nodes.map {|n| n.to_hash}}
		else
			{name => leaf}
		end
	end

	def add_nodes(new_nodes)
		new_nodes.each do |n|
			matching_old_node = find_node(n.name)
			if matching_old_node
				matching_old_node.add_nodes(n.nodes)
			else
				nodes << n
			end
		end
	end

	def find_node(name)
		nodes.each do |n|
			if (n.name == name)
				return n
			end
		end
		return nil
	end

	def to_s(deep)
		result = ''
		if (name == 'ROOT')
			@nodes.each do |n|
				result += n.to_s(deep)
			end
		else
			if nodes.empty?
				result += "#{name}: #{leaf}"
			else
				result += "#{name}:\n"
				nodes.each do |n|	
					result += spaces(deep) + n.to_s(deep + 1) + "\n"
				end
			end		
		end
		result
	end

	def spaces(deep)
		spaces = ''
		deep.times do
			spaces += '  '
		end
		spaces
	end
end

class Prop2Yaml

	def convert(keys, value)
		tree = YamlTree.new

		keys = keys.split('.')
		if (keys.size != 1)
			tree.name = keys[0]
			tree.nodes << convert(keys.drop(1).join("."), value)
		else
			tree.name = keys[0]
			tree.leaf = value
		end
		tree
	end

	def merge(tree1, tree2)
		if (tree1.name == 'ROOT') 
			new_tree = YamlTree.new
			new_tree.name = 'ROOT'
			new_tree.nodes << tree2
			tree2 = new_tree
		end
		if (tree1.name == tree2.name)
			tree1.add_nodes(tree2.nodes)
			tree1
		else
			rootTree = YamlTree.new
			rootTree.name = 'ROOT'
			rootTree.nodes << tree1
			rootTree.nodes << tree2
			rootTree
		end
	end

	def merge_trees(trees)

		merged = nil
		trees.each do |t|
			if merged.nil?
				merged = t
			else
				merged = merge(merged, t)
			end
		end
		merged
	end

end

# require 'java-properties'
# prop2yaml = Prop2Yaml.new

# props = JavaProperties.load(ARGV[0])
# trees = []
# props.each do |key, value|
# 	t = prop2yaml.convert(key.to_s, value)
# 	trees << t
# end

# tree = prop2yaml.merge_trees(trees)
# puts tree.to_s(1)



