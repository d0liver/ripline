# Ripline
Ripline aims to be a centralized, searchable repository for code snippets and
samples. The site is deployed here: [http://RipLine.io](http://RipLine.io).

# Support
Currently there is a Vim plugin at
[TODO](http://github.com/d0liver/vim-ultisnips-ripline) that comes with a couple
of mappings which allow you to expand snippets directly into Vim using
UltiSnips. It should be easy to add support for any other editor plugin since
the whole thing just works by expanding content from the clipboard.  I will
consider writing plugins for other editors/engines if requests are made on
GitHub.  Alternatively, if you wanted to write one and notify me about it so
that I can reference it in this documentation then that would be even better.

# Purpose
Normally, useful code samples are contained within a project's documentation or
found on a Q&A site like StackOverflow. However, this kind of sample inlining
has a couple of inherent problems which, I believe, RipLine solves effectively.

## Easier to Find
The reader doesn't have any control over how or when these samples are updated
and where they exist. Often with documentation for major projects this is not
a huge issue because documentation tends to be easily Googleable and is
generally provided for different API versions. However, this is not always the
case and if you store relevant samples in RipLine then you can be sure that
this won't be an issue for you.

OTOH, for Q&A sites, you may spend hours Googling before actually finding the
question that gives you the answer you're looking for. Or it might be many
questions that give you the answer(s) that you needed for a complete sample.
Furthermore, the questions that gave you your answer might be related only by
happenstance to your original question. In these cases, bookmarking is not a
real answer because you'll have to dig through all of your relevant bookmarks to
find the answer later which is only slightly better than digging through Google
(maybe not even). In these cases, putting together your own comprehensive
examples and having rapid access to them via a system of tags will undoubtedly
save you some time.

## Fork and Iterate
Often, one disagrees with the approach given in the found code sample in subtle
(or not so subtle) ways. For example, I write code in coffee script yet most API
documentation examples are written in javascript. This means that I generally
end up converting samples to coffee before I use them. If I end up using the
same sample code many times across different projects, as is often the case, I
have to translate it each time before I start really manipulating it. Other
times samples will contain relevant API calls but the code itself is poorly
implemented for one reason or another (probably in these cases you should check
with the API docs to make sure the calls are correct). In these cases too, the
samples are valuable to me but I need a good way to iterate and improve on them.
RipLine gives me a good way to modify the samples and still have easy and
searchable access to them later.

__NOTE__: When I say fork and iterate, really what I mean is to copy the sample
into RipLine as a new snippet and tag it appropriately. RipLine doesn't actually
currently have a 'fork' functionality (although it may be added at some point)
but the idea is still there. The important thing is the idea of having your own
version.

## Automatically Indent
Snippet managers like UltiSnips will automatically expand a snippet with your
current indentation settings if you write them with tabs. RipLine will take this
one step further and attempt to automatically convert spaces to tabs in your
uploaded snippets (unless you tell it not to) so that the whole thing is hands
off for you and when you paste a snippet it's automatically pasted with your
configured indentation settings (whatever they may be, expand tabs, etc). This
means that when you copy snippets off of ripline you don't have to mess with
reindenting them.

## No Need to Hilight Before Copying
Once a snippet has been uploaded to RipLine you can just punch the 'copy' button
to get it in your clipboard which means you don't have to hilight the relevant
text which can sometimes be a pain especially for long code snippets on a
laptop.

## Edit Snippets In Your Editor
RipLine aims to make it easy to modify snippets in your text editor and send
them back (paste button) keeping code editing operations in your editor where
they belong.

## Why Not Just Have a Bunch of Snippets Locally?
- You won't have searchable access to other people's snippets that way which is
  REALLY USEFUL. You could download a bunch of snippets from other repositories
  but that's not exactly a nice experience especially when you consider that
  you're then going to have to either manually search through their snippet
  files to find the corresponding triggers or memorize all of them. Trust me, it's not a
  first class solution.
- Every snippet you add to your library pollutes the namespace of your snippet
  triggers a little bit more. It won't be long before every snippet you try to
  expand prompts you for which one of 10 you're actually wanting OR the triggers
  for your snippets look ridiculous like:
  mark112_ultisnips_php_mysql_db_connection.

## Why Not Just Use GitHub Gists?
Frankly, they're just not as good:

- No tagging system. Tags on Stack Overflow make things easy to find and search.
  Without them you are left with descriptions which are less structured and less
  likely to be consistently correct and available. OTOH, RipLine makes tagging
  easy and fun!
- No editor integration
	- No automatic indentation fixes. What a pain.
	- No snippet features. Having placeholders especially with RipLine is really
	  nice - it makes it easy to make sure that you have substituted all of the
	  right information into a code sample before using it.
	- No automatical setting of the filetype for pasted snippets. RipLine will
	  do this soon...
	- The expectation is that you're going to do your editing inside of the
	  browser so the editor to browser transition is not quite as clean and
	  really if I'm going to be editing a gist/snippet I'm pretty much always
	  going to make my edits in the editor (if it's easier).
- AFAIK Everyone is viewing gists with the same trashy theme (unless they are
  viewing it on an external site). RipLine will let you customize your theme -
  soon... In the meantime you get to use Solarized which is already a step up
  IMO.
- I believe that RipLine is just better for a myriad of other small reasons. Try
  it out and tell me what you think. I don't have support for some of the things
  you can do with gists but honestly I think this keeps things very simple and
  very usable. I will always try to focus on keeping the UI as minimal and as
  out of your way as possible and try to make sure that the tool integrates very
  well with other tools. Right now that integration exists solely in the form of
  clipboard messages. In the future I will most likely add publicly accessible
  GraphQL endpoints. Internally GraphQL is being used already so you could hack
  together your own solution for accessing them if you wanted but it's not
  currently documented in any way and you would have to use session based
  authentication.
