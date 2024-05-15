class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  before_action :set_search, only: [:index]
  PAGE_SIZE = 4

  def index
    @page = params.fetch(:page, '1').to_i
    @page_index = @page - 1

    @books = Book.order(created_at: :asc).offset(@page_index * PAGE_SIZE).limit(PAGE_SIZE)

    @total = Book.count
    @total_pages = (@total.to_f / PAGE_SIZE).ceil
  end

  # def index
  #   @books = Book.where("created_at > ?", @after).limit(PAGE_SIZE)
  #   @first_book = nil
  #   @last_book = nil
  # end

  # def index
  #   @books = Book
  #     .where("created_at > ?", @after)
  #     .where("created_at < ?", @before)
  #     .order('created_at' => @sort_param) #, 'id' => @sort_param
  #     .limit(PAGE_SIZE)
  #   @books = @books.reverse if @sort_param == 'desc'
  #   @first_book = @books.first
  #   @last_book = @books.last
  # end



  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to book_url(@book), notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to book_url(@book), notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy!

    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :published_year)
    end

    def set_search
      @query = params
      # @json = params.fetch(:cursor, "{}")
      # @json = Base64.decode64(params.fetch(:cursor, "e30=\n"))
      # @query = JSON.parse(@json)

      @sort_param = @query.fetch('sort', 'asc')
      @after_param = @query.fetch('after', Time.at(0).to_s)
      @before_param = @query.fetch('before', Time.oldest.to_s)
      @after = Time.parse(@after_param)
      @before = Time.parse(@before_param)
      pp @sort_param, @before, @after
    end
end
