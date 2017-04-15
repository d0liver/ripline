{ObjectID} = require 'mongodb'
{buildSchema} = require 'graphql'

SchemaBuilder = (db) ->

	snippets = db.collection 'snippets'

	schema = buildSchema """
		type Snippet {
			_id: String
			text: String
			title: String
			uid: String
		}

		type Query {
			snippet(_id: String!): Snippet
			snippets(text: String!): [Snippet]
		}

		input SnippetPartial {
			title: String
			text: String
			tags: [String]
		}

		type Mutation {
			updateSnippet(update: SnippetPartial!, _id: String!): Boolean
			removeSnippet(_id: String!): Boolean
		}
	"""

	rootValue =
		snippet: ({_id}) ->
			try
				_id = ObjectID _id
				return snippets.findOne {_id}
			catch err
				throw new Exception 'Invalid snippet _id'

		snippets: ({text}) ->
			if text is 'all'
				search = {}
			else
				pieces = text.split /\s+/
				exprs = for piece in pieces
					tags: $regex: "#{piece}"
				search = $and: exprs
			snippets.find(search).toArray()

		updateSnippet: ({_id, update}) ->
			try
				_id = ObjectID _id
			catch err
				throw new Exception 'Invalid snippet _id'

			mongo_update = $set: {}
			for key, value of update
				mongo_update.$set[key] = value

			snippets.updateOne({_id}, mongo_update)
			.then (r) ->
				true

		removeSnippet: ({_id}) ->
			try
				_id = ObjectID _id
			catch err
				throw new Excpetion 'Invalid snippet _id.'

			snippets.remove({_id})

	return {schema, rootValue}

module.exports = SchemaBuilder
