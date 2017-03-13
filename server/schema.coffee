{ObjectID} = require 'mongodb'

SchemaBuilder = (db) ->
	{
		# These are the basic GraphQL types
		GraphQLInt
		GraphQLFloat
		GraphQLString
		GraphQLList
		GraphQLObjectType
		GraphQLEnumType

		# This is used to create required fields and arguments
		GraphQLNonNull

		# This is the class we need to create the schema
		GraphQLSchema

		# This function is used execute GraphQL queries
		graphql
	} = require 'graphql'

	Snippet = new GraphQLObjectType
		name: 'Snippet'
		description: 'This represents a snippet.',
		fields: ->
			_id: type: GraphQLString
			title: type: GraphQLString
			text: type: GraphQLString
			description: type: GraphQLString

	Query = new GraphQLObjectType
		name: 'RiplineSchema',
		description: 'Root schema for ripline',
		fields: ->
			snippet:
				type: Snippet
				description: 'Get snippet info'
				args: _id: type: new GraphQLNonNull GraphQLString
				resolve: (root, {_id}) ->
					try
						_id = ObjectID _id
						return db.collection('snippets').findOne {_id}
					catch err
						return errors: [message: 'Invalid id']
			snippets:
				type: new GraphQLList Snippet
				description: 'Search snippets'
				args: text: type: GraphQLString
				resolve: (root, {text}) ->
					if text is 'all'
						search = {}
					else
						pieces = text.split /\s+/
						exprs = for piece in pieces
							tags: $regex: "#{piece}"
						search = $and: exprs

					db.collection('snippets').find(search).toArray()

	return new GraphQLSchema query: Query

module.exports = SchemaBuilder
