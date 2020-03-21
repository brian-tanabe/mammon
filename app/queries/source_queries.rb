class SourceQueries

	def initialize(user, relation = Source.where(user: user).all)
		@relation = relation
	end

	def sources(&block)
		@relation.find_each(&block)
	end

	def all
		@relation
	end

end