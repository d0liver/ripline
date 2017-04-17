exports.createSampleSnippets = (db) ->
	co ->
		console.log "Creating sample snippets"

		yield db.collection("snippets").insertMany [
				text: "A simple test snippet"
				description: "This is just a simple test snippet"
				tags: ["english"]
			,
				text: "console.log($1);"
				description: "Short javascript console.log"
				tags: ["javascript"]
			,
				text: """
					Lorem ipsum dolor sit amet, consectetur adipiscing elit.
					Donec id sapien nisl. Nam sit amet convallis erat, finibus
					vehicula metus. Pellentesque ullamcorper luctus lacus eget
					blandit. Pellentesque habitant morbi tristique senectus et
					netus et malesuada fames ac turpis egestas. Cras ipsum est,
					dictum nec elit a, condimentum viverra nulla. Integer
					venenatis congue arcu vitae lacinia. Vestibulum tempus eu
					libero varius posuere. Mauris feugiat massa nibh, quis
					ullamcorper sapien mattis vitae. Pellentesque non eleifend
					orci. Integer neque ex, vestibulum vel arcu eget,
					vestibulum convallis mauris. Sed pretium odio sit amet
					tortor mollis, eu eleifend lacus rutrum. Curabitur sit amet
					pharetra est. Curabitur feugiat libero lorem, a finibus
					sapien cursus eget.
				"""
				description: "Lorem Ipsum"
				tags: ["lorem", "ipsum"]
		]
