Communities
===========
- Will be approved by a site moderator to ensure that we don't have overlapping
  communities
- Administration within a particular community will eventually come from the
  roles within that community
  - Admission of Booths into a community will be managed by members in the upper
	echelons of the community (once there are enough). We want to make sure that
	there are enough people in positions to approve these new Booths so that we
	don't have issues with exclusivity (Booths being denied by a few biased
	upper-level community members)

Booths
======
- Communities comprise Booths
- Booths may be made freely if they are private (think friend groups)
- Public Booths must be submitted for approval into any communities that they
  want to be a part of (though this should feel like a lightweight common sense
  thing)

Organizational Differences With Other Tools
===========================================
- Democratized presentation of community content (and edited content)
- Centralized (duplication/fragmentation will be actively prevented by community
  moderation)
- Public communities with anonymity (this way the community is more likely to
  represent the _whole_ community instead of just a small active part of it)

Topic Types
=============
- Events
	- Represent the semantics of an "event" nicely. Users should be able to add
	  events to their calendar and we should have really nice support for
	  community scheduling. At some point people should be able to use common
	  phrases like "I'm free anytime during the evening next week except on
	  Tuesday" to set their availability for their communities (of course this
	  will be __hard__).
- Discussions
	- We should be able to support __huge__ _community discussions_. We're going
	  to do this by having tiers within converstions where only the most upvoted
	  answers are displayed by default (the top 3 or four answers to each
	  comment). Each reply will generate a new level of indentation (or if we're
	  color coding and displaying linearly then a new color) and internally each
	  reply will generate a new anonymous discussion. If people want to then
	  they will be able to create a title for a reply and that reply can become
	  a whole new community topic as its own discussion. Because each response
	  will kickoff a new discussion internally it will be easy to make it so
	  that people can view response threads on another page, etc.
	- We will also have nice support for _delegated discussions_ wherein the
	  community requests that certain individuals have essentially a LD style
	  debate that's publicly available for people to view. This is another way
	  to get really nice cohesive conversations where interests from large
	  groups can be represented by a common message and avoid the sheer number
	  of bulk replies that you would get in a community style chat.
- Questions
	- A _question_ is different from a _discussion_ because it has a clear
	  answer. _Questions_ will have editing enabled like SO and basically we
	  will mimic the SO model and just try to make that model generally
	  available to all kinds of communities whereas SO focuses on IT. (Maybe we
	  should actually just use references to SO sites? See some discussion on
	  when we should integrate vs claim functionality below)
- References
	- References are where we focus on integrating with the rest of the
	  internet. Basic references are probably going to be essentially links.
	  However, we will try to do a good job of integrating with other tools so
	  that references to news show up with nice previews like they would in
	  Slack and other types of integrations show up with content and interaction
	  ability that's specific to their reference type.
- Recursive topics
	- We should be able to attach any kind of topic to any other topic. The
	  relationship here should generally be _x_ "about" _y_ where _x_ is a topic
	  that has been attached to _y_. So, we can have questions about questions,
	  events about events (like a civil war reenactment), discussions about
	  questions, questions about discussions, etc.

Dividing our topic types up like this will really help with a lot of things. One
big example is that with a news feed on the home page we can search for any
topic type which will help us narrow things down really quickly. Of course, this
functionality alone is really not better than a tagging system (which is really
useful actually, look at the popularity of Twitter and SO and how tagging plays
a hugely unique role in those products) and one of those will most likely be
implemented indepently of topic types at some point anyway (because then we can
look at e.g. Vim discussions, topics, references, events). The real power of
this is when we start to attach functionality to specific content types that
represents their semantics. For example, an "Add To Cart" button on an Amazon
reference or the ability to edit responses in questions or the ability to add
events to your calendar straight away.

The recursive nature of the topics working in tandem with these semantic
functionalities I think will make this ridiculously effective. For example, we
could reference a blog post describing a new product as a response to a
discussion question (e.g. what's the best laptop?). To that response we could
attach a reference to the product on Amazon, New Egg, etc. Furthermore, we could
immediately attach references to reviews for that product, topics for questions
about it, and even add events where that product is being discussed. All of
these integrations will have their own semantic functionality attached so the
user could potentially springboard from here and use this to read product
reviews, quickly find the best price for that product, and even purchase it and
attend the con next June.

The response could then easily be broken out into its own topic (by giving it a
title) and made available to others in the community independently of the
question.

All of these things could have been done before but all of them would have
required a lot more legwork on behalf of the users. Here are some reasons why:

For the readers of the response:

- Posting external links to Amazon and New Egg would not have presented the New
  Egg and Amazon logos (as it would with a topic reference) and so someone would
  be forced to write descriptions for those links.
- We wouldn't be able to sort the references attached to the topic if we didn't
  have the notion of these topic types so that's another reason things would
  have been harder to find.
- We would have to export a calendar event after following a link to the con
  (instead of just hitting "add to calendar").
- We would have to use all of the purchasing functionality from the external
  site (Amazon, New Egg) whereas this way you at least get a kick start on that.
- Questions would not be editable (because they would be plain text responses)
  so mistakes would have to be fixed by two or more users (one to suggest the
  fix and the other to accept the suggested changes). We wouldn't be able to
  review those changes generally.

For the contributors to the response:
- Users would not actually attach a full set of references normally (e.g. on SO,
  Reddit, Facebook) because it's just not part of the culture (they don't see
  that it's not there and it's not part of the site policy so there is no
  inclination to try to centralize things)
- There will also be less legwork for people creating the topics that are to be
  attached to the reference (the laptop blog post) because other people will
  also be creating topics on Warren so it is __very likely__ that one or more of
  the topics that needs to be attached has already been created (probably even
  the whole set of references). In that case we're only putting it on the user
  to look them up in Warren and check them off to be attached. This could go
  really quicly.
- If we get an incomplete set of references for the laptop (we will) since the
  thing can be easily broken out into its own thing by giving it a title (and
  this will be very much encouraged) the attached topics will only become more
  complete over time and those updates will show on the response to the
  question.
