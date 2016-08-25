pdf_thumbnailer
==============

`pdf_thumbnailer` converts a folder structure containing `.pdf` files into a folder structure of `.png` files.  Each `.png` represents a single page of the pdf and can be scaled to one or more pixel widths/heights.


Requirements and Dependencies
-----------------------------

Developed/Tested with Ruby version 2.3, but it should work with any version >= 1.9.  Page image creation is done through the `pdftoppm` utility, which can be installed on \*NIX (Linux/OSX) operating systems.


Installation
-----------------------------

Add to your `Gemfile`:

```ruby
gem 'pdf_thumbnailer', '~> 1.0'
```


Usage
-----------------------------

First, configure `PdfThumbs`:

```ruby
PdfThumbs.configure(
  pdf_dir: '/some/path/with/pdf/files',
  img_dir: '/where/to/save/page/images', # required
  thumb_sizes: [1000, 500, 100] # max pixel lengths for the long side (height or width) of the page images
)
```

To generate the page images, execute `.thumbnail!`:

```ruby
PdfThumbs.thumbnail! do |thumb_dir|
  puts "Page thumbnails are located in: #{thumb_dir}"
end
```

`thumbnail!` optionally accepts a code block with one argument.  This argument (`thumb_dir` in the above example) will be a string representing the path of the newly created directory containing page images for a particular pdf.  The folder structure `img_dir` will be identical to that of `pdf_dir` but for every `.pdf` file there will instead be a directory of the same name containing `.png` iamges.

Alternatively a single pdf file can have its pages converted to images using the `thumbnail_single!` method:

```ruby
PdfThumbs.configure img_dir: '/where/to/save/page/images', thumb_sizes: 500

thumb_dir = PdfThumbs.thumbnail_single! '/pdf/root/dir', 'relative/path/to/My File.pdf'

puts "Page thumbnails are located in: #{thumb_dir}"
```


License
-----------------------------

MIT-LICENSE.
