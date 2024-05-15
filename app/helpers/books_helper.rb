module BooksHelper
  def pagination_links total_pages
    (1..total_pages).map do |page|
      link_to page, books_path(page: page)
    end
  end

  def page_links(last_book, first_book = nil)
    [
      link_to('oldest', cursor_path()),
      first_book && link_to('older', cursor_path(sort: 'desc', before: first_book.created_at.iso8601(6))),
      last_book && link_to('newer', cursor_path(sort: 'asc', after: last_book.created_at.iso8601(6))),
      link_to('newest', cursor_path(sort: 'desc', before: Time.oldest.to_s)),
    ].compact
  end

  def cursor_path **args
    books_path(**args)
    # books_path(cursor: args.to_json)
    # books_path(cursor: Base64.encode64(args.to_json))
    end
end
