class Search

  attr_accessor :query, :results

  def initialize(query)
    self.query = query
  end

  def results=(value)
    @results = (value.is_a?(Array) && value.count == 1) ? value.first : value
  end

  def perform
    if query =~ Ticket::REFERENCE_REGEXP
      self.results = Ticket.find_by_reference(query)
    else
      self.results = Ticket.search(query)
    end
    self.results
  end

  def single_result?
    self.results.is_a? Ticket
  end
end