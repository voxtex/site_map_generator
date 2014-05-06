module HTMLMocks

  # Test page containing many different forms of each
  # URI, hopefully covering all edge cases.
  PARSE_TEST = <<-html
  <html>
    <head>
      <script src='http://www.b.com/script.js' />
      <script src='script.js' />
      <link href='http://www.b.com/style.css' />
      <link href='style.css' />
    </head>
    <body>
      <a href='r' />
      <a href='/r-lead.html' />
      <a href='r-trail/' />
      <a href='http://www.a.com' />
      <a href='http://a.com/' />
      <a href='http://s.a.com/' />
      <a href='www.a.com/' />
      <a href='http://www.a.com/a' />
      <a href='http://www.a.com/a/' />
      <a href='http://www.a.com/a/#f?q=p' />
      <a href='http://www.a.com/a/b' />
      <a href='some_crazy:1!2141i' />
      <a href='mailto: test' />
      <a href='javascript: test' />
      <img src='http://www.a.com/image.jpg' />
      <img src='/image.jpg' />
    </body>
  </html>
  html
end