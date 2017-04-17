{ObjectID}             = require 'mongodb'
{GraphQLScalarType}    = require 'graphql'
{makeExecutableSchema} = require 'graphql-tools'
co                     = require 'co'

SchemaBuilder = ({db, user}) ->

	snippets = db.collection 'snippets'
	MongoObjectID = new GraphQLScalarType
		name: 'ObjectID',
		description: 'Mongo ObjectID',
		serialize: (value) -> value.toString()
		parseValue: (value) ->
			try
				return ObjectID value
		parseLiteral: (ast) -> ast.value

	schema = """
		scalar ObjectID
		type Snippet {
			_id: ObjectID
			text: String
			title: String
			username: String
		}

		type Query {
			snippet(_id: ObjectID!): Snippet
			snippets(text: String!): [Snippet]
		}

		input SnippetPartial {
			title: String
			text: String
			tags: [String]
		}

		type Mutation {
			updateSnippet(update: SnippetPartial!, _id: ObjectID!): Boolean
			forkSnippet(_id: ObjectID!): ObjectID
			removeSnippet(_id: ObjectID!): Boolean
		}
	"""

	resolvers =
		ObjectID: MongoObjectID
		Query:
			snippet: ({_id}) -> snippets.findOne {_id}

			snippets: (obj, {text}) ->
				if text is 'all'
					search = {}
				else
					pieces = text.split /\s+/
					exprs = for piece in pieces
						tags: $regex: "#{piece}"
					search = $and: exprs
				snippets.find(search).toArray()

		Mutation:
			# Fork an existing snippet by copying it under the current user.
			# TODO: Make sure the user is logged in here.
			forkSnippet: (obj, {_id}) ->
				return null unless user?
				snippets.findOne {_id}, _id: 0
				.then (template) ->
					template.user = user.displayName
					console.log "Display name: ", user.displayName
					console.log "Inserting template: ", template
					snippets.insertOne template
				.then ({insertedId}) -> insertedId

			updateSnippet: (obj, {_id, update}) ->

				mongo_update = $set: {}
				for key, value of update
					mongo_update.$set[key] = value

				snippets.updateOne({_id}, mongo_update)
				.then (r) ->
					true

			removeSnippet: (obj, {_id}) ->
				snippets.remove({_id})

	return makeExecutableSchema {typeDefs: schema, resolvers}

module.exports = SchemaBuilder
