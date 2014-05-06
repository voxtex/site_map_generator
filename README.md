# Site Map Generator

A simple command line site map generator in Ruby. Crawls a given URL for all static assets and page links. Generates a DOT file and image representing the resulting site map.

## How to use

- Clone the repository.
- Make sure the appropriate version of Ruby is installed. With rbenv

        rbenv install
- Install required gems

        bundle install
- Run the command line script

        ./sitemap http://www.url.com
- If you have problems with gem versions, use

        bundle exec ./sitemap http://www.url.com

## Testing

Run all tests using rspec.
  rspec


## Examples

    ./sitemap -- google.com
hacker news with a depth of 0 and no image,

    ./sitemap -d=0 --no-image news.ycombinator.com

## Notes

- Be careful with specifying a depth, anything over 1 can take a really long time
- Some websites with lots of front page links (www.reddit.com) also take long
- Query parameters are ignored.
- Depth is specified breadth first. 0 = root, 1 = root and all links, etc
- Image files can get quite large. Skip image creation using --no-image
- Change the filename using -f, no need to specify an extension.
- Subdomain is important. a.com is different than www.a.com.
