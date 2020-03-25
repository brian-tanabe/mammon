class ServicerQueries

	def initialize(user, relation = Servicer.where(user: user).all)
		@relation = relation
	end

	def servicers_for_source_type(source_type)
		@relation.where(source_type: source_type).all
	end

	def servicers(&block)
		@relation.find_each(&block)
	end

	def all
		@relation
	end

end